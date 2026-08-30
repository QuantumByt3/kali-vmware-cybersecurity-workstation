<#
.SYNOPSIS
    Checks whether a Windows 11 computer is ready for this VMware + Kali build.

.DESCRIPTION
    This script is read-only. It does not install software or change settings.
#>

$Pass = 0
$Warn = 0
$Fail = 0
$Info = 0

function Write-Result {
    param(
        [ValidateSet('PASS', 'WARN', 'FAIL', 'INFO')]
        [string]$Status,
        [string]$Check,
        [string]$Message
    )

    switch ($Status) {
        'PASS' { $script:Pass++ }
        'WARN' { $script:Warn++ }
        'FAIL' { $script:Fail++ }
        'INFO' { $script:Info++ }
    }

    Write-Output "[$Status] $Check - $Message"
}

Write-Output ""
Write-Output "==============================================="
Write-Output " Windows 11 VMware + Kali Host Readiness Check"
Write-Output "==============================================="
Write-Output ""

# Windows version and architecture
try {
    $OS = Get-CimInstance Win32_OperatingSystem -ErrorAction Stop

    if ($OS.Caption -match 'Windows 11') {
        Write-Result 'PASS' 'Operating system' "$($OS.Caption) detected"
    }
    else {
        Write-Result 'FAIL' 'Operating system' "Windows 11 is required by this guide. Detected: $($OS.Caption)"
    }

    if ($OS.OSArchitecture -match '64') {
        Write-Result 'PASS' 'Architecture' "$($OS.OSArchitecture) detected"
    }
    else {
        Write-Result 'FAIL' 'Architecture' 'A 64-bit Windows installation is required for this build'
    }
}
catch {
    Write-Result 'FAIL' 'Operating system' 'Unable to read Windows operating-system information'
}

# Installed memory
try {
    $Computer = Get-CimInstance Win32_ComputerSystem -ErrorAction Stop
    $MemoryGB = [math]::Round($Computer.TotalPhysicalMemory / 1GB)

    if ($MemoryGB -ge 32) {
        Write-Result 'PASS' 'System memory' "Approximately $MemoryGB GB RAM detected - ideal for larger labs and multiple VMs"
    }
    elseif ($MemoryGB -ge 16) {
        Write-Result 'PASS' 'System memory' "Approximately $MemoryGB GB RAM detected - recommended for a smooth experience"
    }
    elseif ($MemoryGB -ge 8) {
        Write-Result 'PASS' 'System memory' "Approximately $MemoryGB GB RAM detected - workable for a single Kali VM"
    }
    else {
        Write-Result 'WARN' 'System memory' "Approximately $MemoryGB GB RAM detected - this may require additional tuning"
    }
}
catch {
    Write-Result 'WARN' 'System memory' 'Unable to determine installed RAM automatically'
}

# Available storage on the Windows system drive
try {
    $Drive = Get-CimInstance Win32_LogicalDisk `
        -Filter "DeviceID='$env:SystemDrive'" `
        -ErrorAction Stop

    $FreeGB = [math]::Round($Drive.FreeSpace / 1GB, 1)

    if ($FreeGB -ge 100) {
        Write-Result 'PASS' 'Available storage' "$FreeGB GB free on $env:SystemDrive"
    }
    else {
        Write-Result 'WARN' 'Available storage' "$FreeGB GB free on $env:SystemDrive - 100 GB is recommended for this build"
    }
}
catch {
    Write-Result 'WARN' 'Available storage' 'Unable to determine free space automatically'
}

# Hardware virtualization
try {
    $ComputerSystem = Get-CimInstance Win32_ComputerSystem -ErrorAction Stop

    if ($ComputerSystem.HypervisorPresent -eq $true) {
        Write-Result 'PASS' 'Virtualization' 'A Windows hypervisor is active; hardware virtualization is available'
        Write-Result 'INFO' 'Hypervisor mode' 'VMware may use Windows Hypervisor Platform when Windows virtualization security features are active'
    }
    else {
        $Processors = @(Get-CimInstance Win32_Processor -ErrorAction Stop)

        $FirmwareValues = @(
            $Processors |
                ForEach-Object { $_.VirtualizationFirmwareEnabled } |
                Where-Object { $null -ne $_ }
        )

        if ($FirmwareValues.Count -eq 0) {
            Write-Result 'WARN' 'Virtualization' 'Status could not be read automatically. Check Task Manager > Performance > CPU'
        }
        elseif ($FirmwareValues -contains $true) {
            Write-Result 'PASS' 'Virtualization' 'Hardware virtualization is enabled in firmware'
        }
        else {
            Write-Result 'FAIL' 'Virtualization' 'Hardware virtualization appears disabled in BIOS/UEFI'
        }
    }
}
catch {
    Write-Result 'WARN' 'Virtualization' 'Unable to determine status automatically. Check Task Manager > Performance > CPU'
}

# Common pending-restart indicators
$RestartPending = $false

$RestartKeys = @(
    'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\RebootPending',
    'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\RebootRequired'
)

foreach ($Key in $RestartKeys) {
    if (Test-Path -LiteralPath $Key) {
        $RestartPending = $true
    }
}

$PendingRename = Get-ItemProperty `
    -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager' `
    -Name 'PendingFileRenameOperations' `
    -ErrorAction SilentlyContinue

if ($null -ne $PendingRename.PendingFileRenameOperations) {
    $RestartPending = $true
}

if ($RestartPending) {
    Write-Result 'WARN' 'Pending restart' 'Windows reports a pending restart; reboot when practical before major workstation changes'
}
else {
    Write-Result 'PASS' 'Pending restart' 'No common pending-restart indicators detected'
}

# Windows Update cannot be reliably confirmed by this basic local check.
Write-Result 'INFO' 'Windows Update' 'Open Settings > Windows Update and check for updates before continuing'

Write-Output ""
Write-Output "==============================================="
Write-Output " Host Readiness Summary"
Write-Output "==============================================="
Write-Output "PASS : $Pass"
Write-Output "WARN : $Warn"
Write-Output "FAIL : $Fail"
Write-Output "INFO : $Info"
Write-Output ""

if ($Fail -gt 0) {
    Write-Output 'Overall Result: NOT READY'
    Write-Output 'Resolve failed checks before installing VMware Workstation Pro.'
    exit 1
}

if ($Warn -gt 0) {
    Write-Output 'Overall Result: READY WITH REVIEW'
    Write-Output 'Review warnings before continuing.'
    exit 0
}

Write-Output 'Overall Result: READY'
exit 0
