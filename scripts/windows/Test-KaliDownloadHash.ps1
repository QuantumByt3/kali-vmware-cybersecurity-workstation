<#
.SYNOPSIS
    Verifies the SHA-256 hash of a downloaded Kali Linux VMware archive.

.DESCRIPTION
    This script is read-only. It calculates the SHA-256 hash of a local Kali
    VMware archive and compares it with the official hash copied from kali.org.

.PARAMETER ArchivePath
    Path to the downloaded Kali VMware .7z archive.

.PARAMETER ExpectedHash
    Official 64-character SHA-256 value published by Kali Linux.

.EXAMPLE
    .\Test-KaliDownloadHash.ps1 `
        -ArchivePath "$HOME\Downloads\kali-linux-2026.2-vmware-amd64.7z" `
        -ExpectedHash "c65145cef70166889e7283a230e88c832eaa8077e6e7cd37b47c0ccdc05685b0"
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]$ArchivePath,

    [Parameter(Mandatory)]
    [ValidatePattern('^[A-Fa-f0-9]{64}$')]
    [string]$ExpectedHash
)

$Pass = 0
$Fail = 0
$Info = 0

function Write-Result {
    param(
        [ValidateSet('PASS', 'FAIL', 'INFO')]
        [string]$Status,

        [string]$Check,
        [string]$Message
    )

    switch ($Status) {
        'PASS' { $script:Pass++ }
        'FAIL' { $script:Fail++ }
        'INFO' { $script:Info++ }
    }

    Write-Output "[$Status] $Check - $Message"
}

Write-Output ""
Write-Output "==============================================="
Write-Output " Kali VMware Download Integrity Check"
Write-Output "==============================================="
Write-Output ""

try {
    $ResolvedArchive = Resolve-Path `
        -LiteralPath $ArchivePath `
        -ErrorAction Stop

    $Archive = Get-Item `
        -LiteralPath $ResolvedArchive.Path `
        -ErrorAction Stop

    if ($Archive.PSIsContainer) {
        Write-Result 'FAIL' 'Archive' 'The supplied path points to a directory, not a file'
    }
    elseif ($Archive.Extension -ne '.7z') {
        Write-Result 'FAIL' 'Archive' 'The supplied file is not a .7z archive'
    }
    elseif ($Archive.Name -notmatch '^kali-linux-.+-vmware-amd64\.7z$') {
        Write-Result 'FAIL' 'Archive' 'The filename does not match the expected Kali VMware amd64 archive format'
    }
    else {
        Write-Result 'PASS' 'Archive' "Kali VMware archive found: $($Archive.Name)"
        Write-Result 'INFO' 'Archive size' "$([math]::Round($Archive.Length / 1GB, 2)) GB"

        try {
            $CalculatedHash = (
                Get-FileHash `
                    -LiteralPath $Archive.FullName `
                    -Algorithm SHA256 `
                    -ErrorAction Stop
            ).Hash

            Write-Result 'INFO' 'Expected SHA-256' $ExpectedHash.ToLowerInvariant()
            Write-Result 'INFO' 'Calculated SHA-256' $CalculatedHash.ToLowerInvariant()

            if ($CalculatedHash -ieq $ExpectedHash) {
                Write-Result 'PASS' 'SHA-256 verification' 'Calculated hash matches the official expected hash'
            }
            else {
                Write-Result 'FAIL' 'SHA-256 verification' 'Calculated hash does not match the official expected hash'
            }
        }
        catch {
            Write-Result 'FAIL' 'SHA-256 verification' 'Unable to calculate the archive hash'
        }
    }
}
catch {
    Write-Result 'FAIL' 'Archive' "File not found: $ArchivePath"
}

Write-Output ""
Write-Output "==============================================="
Write-Output " Kali Download Verification Summary"
Write-Output "==============================================="
Write-Output "PASS : $Pass"
Write-Output "FAIL : $Fail"
Write-Output "INFO : $Info"
Write-Output ""

if ($Fail -gt 0) {
    Write-Output 'Overall Result: VERIFICATION FAILED'
    Write-Output 'Do not extract or open the Kali archive.'
    exit 1
}

Write-Output 'Overall Result: KALI DOWNLOAD VERIFIED'
Write-Output 'The archive may now be extracted.'
exit 0
