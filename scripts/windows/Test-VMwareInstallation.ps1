<#
.SYNOPSIS
    Verifies a VMware Workstation Pro installation on Windows 11.

.DESCRIPTION
    This script is read-only. It does not install, update, or modify VMware.
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
Write-Output " VMware Workstation Pro Installation Check"
Write-Output "==============================================="
Write-Output ""

# Locate VMware Workstation without using Win32_Product.
$CandidatePaths = @(
    "$env:ProgramFiles\VMware\VMware Workstation\vmware.exe",
    "${env:ProgramFiles(x86)}\VMware\VMware Workstation\vmware.exe"
) | Where-Object { -not [string]::IsNullOrWhiteSpace($_) }

$Command = Get-Command vmware.exe -ErrorAction SilentlyContinue

if ($null -ne $Command) {
    $CandidatePaths += $Command.Source
}

$VmwarePath = $CandidatePaths |
    Where-Object { Test-Path -LiteralPath $_ -PathType Leaf } |
    Select-Object -First 1

if ($null -eq $VmwarePath) {
    Write-Result 'FAIL' 'VMware executable' 'vmware.exe was not found in the standard installation locations'
}
else {
    Write-Result 'PASS' 'VMware executable' 'VMware Workstation executable found'

    try {
        $VersionInfo = (Get-Item -LiteralPath $VmwarePath -ErrorAction Stop).VersionInfo

        $ProductName = $VersionInfo.ProductName
        $ProductVersion = $VersionInfo.ProductVersion

        if ([string]::IsNullOrWhiteSpace($ProductName)) {
            $ProductName = 'VMware Workstation'
        }

        if ([string]::IsNullOrWhiteSpace($ProductVersion)) {
            Write-Result 'WARN' 'VMware version' "$ProductName detected, but the version could not be read"
        }
        else {
            Write-Result 'PASS' 'VMware version' "$ProductName $ProductVersion"
        }
    }
    catch {
        Write-Result 'WARN' 'VMware version' 'The VMware executable was found, but its version could not be read'
    }

    try {
        $Signature = Get-AuthenticodeSignature -FilePath $VmwarePath -ErrorAction Stop

        if ($Signature.Status -eq 'Valid') {
            Write-Result 'PASS' 'Digital signature' 'Installed VMware executable has a valid Authenticode signature'
        }
        else {
            Write-Result 'FAIL' 'Digital signature' "Signature status: $($Signature.Status)"
        }
    }
    catch {
        Write-Result 'WARN' 'Digital signature' 'Unable to verify the installed VMware executable signature'
    }
}

# Check the VMware Authorization Service.
$AuthService = Get-Service -Name 'VMAuthdService' -ErrorAction SilentlyContinue

if ($null -eq $AuthService) {
    Write-Result 'WARN' 'VMware Authorization Service' 'VMAuthdService was not found'
}
else {
    if ($AuthService.Status -eq 'Running') {
        Write-Result 'PASS' 'VMware Authorization Service' 'Service is running'
    }
    else {
        Write-Result 'INFO' 'VMware Authorization Service' "Service exists and is currently $($AuthService.Status)"
    }
}

# Check for VMware virtual network adapters.
try {
    $VmwareAdapters = @(
        Get-NetAdapter -ErrorAction Stop |
            Where-Object { $_.InterfaceDescription -match 'VMware' }
    )

    if ($VmwareAdapters.Count -gt 0) {
        $AdapterNames = ($VmwareAdapters.Name | Sort-Object) -join ', '
        Write-Result 'PASS' 'VMware networking' "VMware network adapter(s) detected: $AdapterNames"
    }
    else {
        Write-Result 'WARN' 'VMware networking' 'No VMware virtual network adapters were detected'
    }
}
catch {
    Write-Result 'WARN' 'VMware networking' 'Unable to inspect Windows network adapters'
}

# Report whether a Windows hypervisor is active.
try {
    $ComputerSystem = Get-CimInstance Win32_ComputerSystem -ErrorAction Stop

    if ($ComputerSystem.HypervisorPresent -eq $true) {
        Write-Result 'INFO' 'Windows hypervisor' 'A Windows hypervisor is active'
    }
    else {
        Write-Result 'INFO' 'Windows hypervisor' 'No active Windows hypervisor was reported'
    }
}
catch {
    Write-Result 'INFO' 'Windows hypervisor' 'Hypervisor status could not be determined automatically'
}

Write-Output ""
Write-Output "==============================================="
Write-Output " VMware Installation Summary"
Write-Output "==============================================="
Write-Output "PASS : $Pass"
Write-Output "WARN : $Warn"
Write-Output "FAIL : $Fail"
Write-Output "INFO : $Info"
Write-Output ""

if ($Fail -gt 0) {
    Write-Output 'Overall Result: VMWARE INSTALLATION NEEDS ATTENTION'
    exit 1
}

if ($Warn -gt 0) {
    Write-Output 'Overall Result: VMWARE INSTALLED WITH REVIEW ITEMS'
    exit 0
}

Write-Output 'Overall Result: VMWARE INSTALLATION VERIFIED'
exit 0
