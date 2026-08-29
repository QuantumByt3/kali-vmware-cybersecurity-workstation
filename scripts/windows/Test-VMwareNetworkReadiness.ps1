#requires -Version 5.1

<#
.SYNOPSIS
Performs a read-only VMware Workstation networking readiness check on Windows.

.DESCRIPTION
Checks the expected VMware host-only and NAT virtual adapters, VMware DHCP and
NAT services, authorization service, and Windows hypervisor state without
printing private IP addresses, gateways, DNS servers, or MAC addresses.

This script does not modify adapters, services, routes, firewall rules, VMware
settings, or Windows networking configuration.
#>

[CmdletBinding()]
param()

$PassCount = 0
$WarnCount = 0
$FailCount = 0
$InfoCount = 0

function Write-Result {
    param(
        [Parameter(Mandatory)]
        [ValidateSet('PASS', 'WARN', 'FAIL', 'INFO')]
        [string]$Status,

        [Parameter(Mandatory)]
        [string]$Check,

        [Parameter(Mandatory)]
        [string]$Message
    )

    switch ($Status) {
        'PASS' { $script:PassCount++ }
        'WARN' { $script:WarnCount++ }
        'FAIL' { $script:FailCount++ }
        'INFO' { $script:InfoCount++ }
    }

    Write-Host "[$Status] $Check - $Message"
}

function Complete-Check {
    Write-Host ''
    Write-Host '==============================================='
    Write-Host ' VMware Network Readiness Summary'
    Write-Host '==============================================='
    Write-Host "PASS : $PassCount"
    Write-Host "WARN : $WarnCount"
    Write-Host "FAIL : $FailCount"
    Write-Host "INFO : $InfoCount"
    Write-Host ''

    if ($FailCount -gt 0) {
        Write-Host 'Overall Result: VMWARE NETWORK READINESS NEEDS ATTENTION'
        exit 1
    }

    if ($WarnCount -gt 0) {
        Write-Host 'Overall Result: VMWARE NETWORK READY WITH REVIEW ITEMS'
        exit 0
    }

    Write-Host 'Overall Result: VMWARE NETWORK READINESS VERIFIED'
    exit 0
}

Write-Host ''
Write-Host '==============================================='
Write-Host ' VMware Workstation Network Readiness Check'
Write-Host '==============================================='
Write-Host ''

try {
    $os = Get-CimInstance -ClassName Win32_OperatingSystem -ErrorAction Stop
    if ($os.Caption -match 'Windows 11') {
        Write-Result -Status PASS -Check 'Operating system' -Message $os.Caption
    }
    else {
        Write-Result -Status WARN -Check 'Operating system' -Message "Detected: $($os.Caption)"
    }
}
catch {
    Write-Result -Status FAIL -Check 'Operating system' -Message 'Unable to query Windows operating system information'
}

try {
    $computerSystem = Get-CimInstance -ClassName Win32_ComputerSystem -ErrorAction Stop
    if ($computerSystem.HypervisorPresent) {
        Write-Result -Status PASS -Check 'Hypervisor' -Message 'Windows reports an active hypervisor'
    }
    else {
        Write-Result -Status WARN -Check 'Hypervisor' -Message 'Windows does not report an active hypervisor'
    }
}
catch {
    Write-Result -Status WARN -Check 'Hypervisor' -Message 'Unable to query hypervisor state'
}

$requiredAdapters = @(
    'VMware Network Adapter VMnet1',
    'VMware Network Adapter VMnet8'
)

foreach ($adapterName in $requiredAdapters) {
    try {
        $adapter = Get-NetAdapter -Name $adapterName -ErrorAction Stop

        if ($adapter.Status -eq 'Up') {
            Write-Result -Status PASS -Check $adapterName -Message 'Adapter is present and Up'
        }
        else {
            Write-Result -Status WARN -Check $adapterName -Message "Adapter is present but status is $($adapter.Status)"
        }
    }
    catch {
        Write-Result -Status FAIL -Check $adapterName -Message 'Expected VMware virtual adapter was not found'
    }
}

try {
    $vmwareAdapters = @(
        Get-NetAdapter -ErrorAction Stop |
            Where-Object {
                $_.Name -match 'VMware|VMnet' -or
                $_.InterfaceDescription -match 'VMware'
            }
    )

    if ($vmwareAdapters.Count -ge 2) {
        Write-Result -Status PASS -Check 'VMware adapters' -Message "Detected $($vmwareAdapters.Count) VMware virtual adapters"
    }
    elseif ($vmwareAdapters.Count -eq 1) {
        Write-Result -Status WARN -Check 'VMware adapters' -Message 'Only one VMware virtual adapter was detected'
    }
    else {
        Write-Result -Status FAIL -Check 'VMware adapters' -Message 'No VMware virtual adapters were detected'
    }
}
catch {
    Write-Result -Status FAIL -Check 'VMware adapters' -Message 'Unable to enumerate Windows network adapters'
}

$requiredServices = @(
    @{
        Name = 'VMAuthdService'
        Label = 'VMware Authorization Service'
    },
    @{
        Name = 'VMnetDHCP'
        Label = 'VMware DHCP Service'
    },
    @{
        Name = 'VMware NAT Service'
        Label = 'VMware NAT Service'
    }
)

foreach ($serviceDefinition in $requiredServices) {
    try {
        $service = Get-Service -Name $serviceDefinition.Name -ErrorAction Stop

        if ($service.Status -eq 'Running') {
            Write-Result -Status PASS -Check $serviceDefinition.Label -Message 'Service is running'
        }
        else {
            Write-Result -Status WARN -Check $serviceDefinition.Label -Message "Service status is $($service.Status)"
        }

        if ($service.StartType -eq 'Automatic') {
            Write-Result -Status PASS -Check "$($serviceDefinition.Label) startup" -Message 'Startup type is Automatic'
        }
        else {
            Write-Result -Status INFO -Check "$($serviceDefinition.Label) startup" -Message "Startup type is $($service.StartType)"
        }
    }
    catch {
        Write-Result -Status FAIL -Check $serviceDefinition.Label -Message 'Required VMware service was not found'
    }
}

try {
    $vmnet1Config = Get-NetIPConfiguration -InterfaceAlias 'VMware Network Adapter VMnet1' -ErrorAction Stop
    if ($vmnet1Config.IPv4Address) {
        Write-Result -Status PASS -Check 'VMnet1 IPv4' -Message 'Host-only adapter has an IPv4 configuration'
    }
    else {
        Write-Result -Status WARN -Check 'VMnet1 IPv4' -Message 'Host-only adapter has no IPv4 address'
    }
}
catch {
    Write-Result -Status WARN -Check 'VMnet1 IPv4' -Message 'Unable to query host-only IPv4 configuration'
}

try {
    $vmnet8Config = Get-NetIPConfiguration -InterfaceAlias 'VMware Network Adapter VMnet8' -ErrorAction Stop
    if ($vmnet8Config.IPv4Address) {
        Write-Result -Status PASS -Check 'VMnet8 IPv4' -Message 'NAT adapter has an IPv4 configuration'
    }
    else {
        Write-Result -Status WARN -Check 'VMnet8 IPv4' -Message 'NAT adapter has no IPv4 address'
    }
}
catch {
    Write-Result -Status WARN -Check 'VMnet8 IPv4' -Message 'Unable to query NAT IPv4 configuration'
}

Write-Result -Status INFO -Check 'VMnet1 role' -Message 'VMnet1 is the expected VMware host-only network on a standard Workstation configuration'
Write-Result -Status INFO -Check 'VMnet8 role' -Message 'VMnet8 is the expected VMware NAT network on a standard Workstation configuration'
Write-Result -Status INFO -Check 'Privacy' -Message 'Private IP addresses, gateways, DNS servers, and MAC addresses were intentionally not printed'
Write-Result -Status INFO -Check 'Scope' -Message 'This script made no changes to Windows, VMware, services, adapters, routes, or firewall rules'
Write-Result -Status INFO -Check 'Guest validation' -Message 'Confirm the Kali guest network separately with Test-KaliNetworkReadiness.sh'

Complete-Check
