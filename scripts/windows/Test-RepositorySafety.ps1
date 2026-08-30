#requires -Version 5.1

[CmdletBinding()]
param()

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Write-Section {
    param(
        [Parameter(Mandatory)]
        [string]$Title
    )

    Write-Host ""
    Write-Host "=== $Title ==="
}

function Add-Finding {
    param(
        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [System.Collections.Generic.List[object]]$List,

        [Parameter(Mandatory)]
        [string]$File,

        [Parameter(Mandatory)]
        [string]$Category,

        [int]$Line = 0
    )

    $List.Add(
        [PSCustomObject]@{
            File     = $File
            Line     = $Line
            Category = $Category
        }
    )
}

Write-Section "Repository Safety Validation"

$RepoRoot = git rev-parse --show-toplevel 2>$null

if ($LASTEXITCODE -ne 0 -or [string]::IsNullOrWhiteSpace($RepoRoot)) {
    Write-Host "[FAIL] This script must be run inside a Git repository."
    exit 1
}

$RepoRoot = $RepoRoot.Trim()
Set-Location -LiteralPath $RepoRoot

Write-Host "[PASS] Repository detected."

$PublishableFiles = @(
    git ls-files --cached --others --exclude-standard |
        Where-Object { $_ -and $_.Trim() -ne '' } |
        Sort-Object -Unique
)

if ($LASTEXITCODE -ne 0) {
    Write-Host "[FAIL] Unable to enumerate publishable repository files."
    exit 1
}

Write-Host "Publishable files: $($PublishableFiles.Count)"

$TextExtensions = @(
    '.md',
    '.txt',
    '.ps1',
    '.psm1',
    '.psd1',
    '.sh',
    '.bash',
    '.zsh',
    '.py',
    '.json',
    '.yaml',
    '.yml',
    '.toml',
    '.ini',
    '.conf'
)

$TextFiles = @(
    $PublishableFiles |
        Where-Object {
            $Extension = [System.IO.Path]::GetExtension($_).ToLowerInvariant()

            $TextExtensions -contains $Extension -or
            $_ -eq '.gitignore' -or
            $_ -eq '.gitattributes' -or
            $_ -eq 'LICENSE'
        }
)

Write-Host "Text files: $($TextFiles.Count)"

Write-Section "Forbidden Artifact Scan"

$ForbiddenFindings = [System.Collections.Generic.List[object]]::new()

$ForbiddenFilePatterns = @(
    '(?i)\.env$',
    '(?i)\.(?:key|pem|pfx|p12)$',
    '(?i)\.(?:ovpn|vpn|mobileconfig)$',
    '(?i)\.(?:vmdk|vmx|vmxf|vmsd|vmsn|vmem|vmss|nvram|lck)$',
    '(?i)\.(?:vhd|vhdx|qcow|qcow2|vdi)$',
    '(?i)\.(?:iso|img)$',
    '(?i)\.(?:zip|7z|rar|tar|tar\.gz|tgz|deb)$',
    '(?i)\.(?:pcap|pcapng|cap|etl)$',
    '(?i)\.(?:pml|evtx|dmp|dump|raw|mem|hiv)$',
    '(?i)\.nessus$',
    '(?i)\.har$'
)

$ForbiddenPathPatterns = @(
    '(?i)(^|/)private/',
    '(?i)(^|/)assets/raw-screenshots/',
    '(?i)(^|/)evidence/',
    '(?i)(^|/)captures/',
    '(?i)(^|/)artifacts/',
    '(?i)(^|/)cases/',
    '(?i)(^|/)wordlists/',
    '(?i)(^|/)downloads/',
    '(?i)(^|/)tools/downloads/'
)

foreach ($RelativeFile in $PublishableFiles) {
    $Normalized = $RelativeFile -replace '\\', '/'

    foreach ($Pattern in $ForbiddenFilePatterns) {
        if ($Normalized -match $Pattern) {
            Add-Finding `
                -List $ForbiddenFindings `
                -File $RelativeFile `
                -Category 'Forbidden file type'
            break
        }
    }

    foreach ($Pattern in $ForbiddenPathPatterns) {
        if ($Normalized -match $Pattern) {
            Add-Finding `
                -List $ForbiddenFindings `
                -File $RelativeFile `
                -Category 'Private or evidence directory'
            break
        }
    }
}

if ($ForbiddenFindings.Count -eq 0) {
    Write-Host "[PASS] No forbidden publishable artifacts found."
}
else {
    Write-Host "[FAIL] Forbidden publishable artifacts found:"
    $ForbiddenFindings |
        Sort-Object File, Category -Unique |
        Format-Table File, Category -AutoSize
}

Write-Host "Forbidden artifact findings: $($ForbiddenFindings.Count)"

Write-Section "Sensitive Content Scan"

$SensitiveFindings = [System.Collections.Generic.List[object]]::new()

$SensitivePatterns = @(
    @{
        Name    = 'Windows user-profile path'
        Pattern = '(?i)[A-Z]:\\Users\\[^\\\r\n]+'
    },
    @{
        Name    = 'Email address'
        Pattern = '(?i)\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}\b'
    },
    @{
        Name    = 'Private IPv4 address'
        Pattern = '\b(?:10\.(?:\d{1,3}\.){2}\d{1,3}|192\.168\.(?:\d{1,3}\.)\d{1,3}|172\.(?:1[6-9]|2\d|3[01])\.(?:\d{1,3}\.)\d{1,3})\b'
    },
    @{
        Name    = 'MAC address'
        Pattern = '(?i)\b(?:[0-9A-F]{2}[:-]){5}[0-9A-F]{2}\b'
    },
    @{
        Name    = 'Private key material'
        Pattern = '-----BEGIN (?:RSA |EC |OPENSSH )?PRIVATE KEY-----'
    },
    @{
        Name    = 'GitHub access token'
        Pattern = '\bgh[pousr]_[A-Za-z0-9_]{20,}\b'
    },
    @{
        Name    = 'AWS access key'
        Pattern = '\bAKIA[0-9A-Z]{16}\b'
    },
    @{
        Name    = 'Generic bearer token assignment'
        Pattern = '(?i)\b(?:token|api[_-]?key|secret)\s*[:=]\s*["''][A-Za-z0-9_\-\.]{16,}["'']'
    }
)

foreach ($RelativeFile in $TextFiles) {
    $FullPath = Join-Path $RepoRoot $RelativeFile

    if (-not (Test-Path -LiteralPath $FullPath -PathType Leaf)) {
        continue
    }

    $LineNumber = 0

    foreach ($Line in Get-Content -LiteralPath $FullPath) {
        $LineNumber++

        foreach ($Check in $SensitivePatterns) {
            if ($Line -notmatch $Check.Pattern) {
                continue
            }

            if (
                $Check.Name -eq 'Windows user-profile path' -and
                $Line -match '<your-username>|<username>|<user>'
            ) {
                continue
            }

            if (
                $Check.Name -eq 'Email address' -and
                $Line -match '(?i)@example\.(com|org|net)\b'
            ) {
                continue
            }

            if (
                $Check.Name -eq 'Private IPv4 address' -and
                $Line -match '<[^>]*ip[^>]*>|<private-ip>|<gateway>'
            ) {
                continue
            }

            Add-Finding `
                -List $SensitiveFindings `
                -File $RelativeFile `
                -Line $LineNumber `
                -Category $Check.Name
        }
    }
}

if ($SensitiveFindings.Count -eq 0) {
    Write-Host "[PASS] No sensitive-content patterns found."
}
else {
    Write-Host "[REVIEW] Potential sensitive-content findings:"
    $SensitiveFindings |
        Sort-Object File, Line, Category -Unique |
        Format-Table File, Line, Category -AutoSize
}

Write-Host "Sensitive findings: $($SensitiveFindings.Count)"

Write-Section "Unfinished Content Scan"

$UnfinishedFindings = [System.Collections.Generic.List[object]]::new()

$UnfinishedPatterns = @(
    '\b' + 'TO' + 'DO' + '\b',
    '\b' + 'FIX' + 'ME' + '\b',
    '\b' + 'T' + 'BD' + '\b',
    '\b' + 'T' + 'BA' + '\b',
    '\b' + 'W' + 'IP' + '\b',
    '\b' + 'DR' + 'AFT' + '\b',
    '\b' + 'PLACE' + 'HOLDER' + '\b',
    'REPLACE' + ' ME',
    'COMING' + ' SOON',
    'UNDER ACTIVE' + ' DEVELOPMENT',
    'WORK IN' + ' PROGRESS',
    'Lorem' + ' ipsum'
)

foreach ($RelativeFile in $TextFiles) {
    $FullPath = Join-Path $RepoRoot $RelativeFile

    if (-not (Test-Path -LiteralPath $FullPath -PathType Leaf)) {
        continue
    }

    $LineNumber = 0

    foreach ($Line in Get-Content -LiteralPath $FullPath) {
        $LineNumber++

        foreach ($Pattern in $UnfinishedPatterns) {
            if ($Line -match "(?i)$Pattern") {
                Add-Finding `
                    -List $UnfinishedFindings `
                    -File $RelativeFile `
                    -Line $LineNumber `
                    -Category 'Unfinished-content marker'
                break
            }
        }
    }
}

if ($UnfinishedFindings.Count -eq 0) {
    Write-Host "[PASS] No unfinished-content markers found."
}
else {
    Write-Host "[REVIEW] Unfinished-content markers found:"
    $UnfinishedFindings |
        Sort-Object File, Line -Unique |
        Format-Table File, Line -AutoSize
}

Write-Host "Unfinished-content findings: $($UnfinishedFindings.Count)"

Write-Section "Line Ending Scan"

$CRLFFiles = [System.Collections.Generic.List[string]]::new()
$LoneCRFiles = [System.Collections.Generic.List[string]]::new()
$LFFiles = [System.Collections.Generic.List[string]]::new()
$EmptyFiles = [System.Collections.Generic.List[string]]::new()

foreach ($RelativeFile in $TextFiles) {
    $FullPath = Join-Path $RepoRoot $RelativeFile

    if (-not (Test-Path -LiteralPath $FullPath -PathType Leaf)) {
        continue
    }

    $Bytes = [System.IO.File]::ReadAllBytes($FullPath)

    if ($Bytes.Length -eq 0) {
        $EmptyFiles.Add($RelativeFile)
        continue
    }

    $HasCRLF = $false
    $HasLoneCR = $false
    $HasLF = $false

    for ($Index = 0; $Index -lt $Bytes.Length; $Index++) {
        if ($Bytes[$Index] -eq 10) {
            $HasLF = $true
        }

        if ($Bytes[$Index] -eq 13) {
            if (
                $Index + 1 -lt $Bytes.Length -and
                $Bytes[$Index + 1] -eq 10
            ) {
                $HasCRLF = $true
            }
            else {
                $HasLoneCR = $true
            }
        }
    }

    if ($HasCRLF) {
        $CRLFFiles.Add($RelativeFile)
    }
    elseif ($HasLoneCR) {
        $LoneCRFiles.Add($RelativeFile)
    }
    elseif ($HasLF) {
        $LFFiles.Add($RelativeFile)
    }
}

Write-Host "Text files checked : $($TextFiles.Count)"
Write-Host "LF files           : $($LFFiles.Count)"
Write-Host "CRLF files         : $($CRLFFiles.Count)"
Write-Host "Lone-CR files      : $($LoneCRFiles.Count)"
Write-Host "Empty text files   : $($EmptyFiles.Count)"

if ($CRLFFiles.Count -gt 0) {
    Write-Host "[FAIL] CRLF files:"
    $CRLFFiles | ForEach-Object { Write-Host "       $_" }
}

if ($LoneCRFiles.Count -gt 0) {
    Write-Host "[FAIL] Lone-CR files:"
    $LoneCRFiles | ForEach-Object { Write-Host "       $_" }
}

if ($CRLFFiles.Count -eq 0 -and $LoneCRFiles.Count -eq 0) {
    Write-Host "[PASS] Repository text files use LF line endings."
}

Write-Section "Internal Markdown Link Scan"

$MarkdownFiles = @(
    $TextFiles |
        Where-Object { $_ -match '\.md$' }
)

$BrokenLinks = [System.Collections.Generic.List[object]]::new()
$InternalLinksChecked = 0

foreach ($RelativeFile in $MarkdownFiles) {
    $FullPath = Join-Path $RepoRoot $RelativeFile
    $SourceDirectory = Split-Path -Parent $FullPath

    if ([string]::IsNullOrWhiteSpace($SourceDirectory)) {
        $SourceDirectory = $RepoRoot
    }

    $LineNumber = 0

    foreach ($Line in Get-Content -LiteralPath $FullPath) {
        $LineNumber++

        $LinkMatches = [regex]::Matches(
            $Line,
            '\[[^\]]*\]\(([^)]+)\)'
        )

        foreach ($Match in $LinkMatches) {
            $Target = $Match.Groups[1].Value.Trim()

            if (
                [string]::IsNullOrWhiteSpace($Target) -or
                $Target -match '^(https?://|mailto:|#)'
            ) {
                continue
            }

            $TargetWithoutAnchor = ($Target -split '#', 2)[0]

            if ([string]::IsNullOrWhiteSpace($TargetWithoutAnchor)) {
                continue
            }

            $TargetWithoutAnchor = [System.Uri]::UnescapeDataString(
                $TargetWithoutAnchor
            )

            $ResolvedPath = Join-Path $SourceDirectory $TargetWithoutAnchor
            $InternalLinksChecked++

            if (-not (Test-Path -LiteralPath $ResolvedPath)) {
                Add-Finding `
                    -List $BrokenLinks `
                    -File $RelativeFile `
                    -Line $LineNumber `
                    -Category "Broken link: $Target"
            }
        }
    }
}

Write-Host "Internal links checked: $InternalLinksChecked"
Write-Host "Broken internal links : $($BrokenLinks.Count)"

if ($BrokenLinks.Count -eq 0) {
    Write-Host "[PASS] All checked internal Markdown links resolve."
}
else {
    Write-Host "[FAIL] Broken internal Markdown links found:"
    $BrokenLinks |
        Sort-Object File, Line, Category |
        Format-Table File, Line, Category -AutoSize
}

Write-Section "Documented Repository Path Scan"

$DocumentedPaths = [System.Collections.Generic.List[object]]::new()

foreach ($RelativeFile in $MarkdownFiles) {
    $FullPath = Join-Path $RepoRoot $RelativeFile
    $LineNumber = 0

    foreach ($Line in Get-Content -LiteralPath $FullPath) {
        $LineNumber++

        $PathMatches = [regex]::Matches(
            $Line,
            '(?<![A-Za-z0-9._/-])((?:scripts|docs)/[A-Za-z0-9._/-]+\.(?:ps1|sh|md))(?![A-Za-z0-9._/-])'
        )

        foreach ($Match in $PathMatches) {
            $DocumentedPaths.Add(
                [PSCustomObject]@{
                    Source = $RelativeFile
                    Line   = $LineNumber
                    Target = $Match.Groups[1].Value
                }
            )
        }
    }
}

$DocumentedPaths = @(
    $DocumentedPaths |
        Sort-Object Source, Line, Target -Unique
)

$MissingDocumentedPaths = [System.Collections.Generic.List[object]]::new()

foreach ($Reference in $DocumentedPaths) {
    $TargetPath = Join-Path $RepoRoot (
        $Reference.Target -replace '/', [IO.Path]::DirectorySeparatorChar
    )

    if (-not (Test-Path -LiteralPath $TargetPath -PathType Leaf)) {
        $MissingDocumentedPaths.Add($Reference)
    }
}

Write-Host "Documented paths checked : $($DocumentedPaths.Count)"
Write-Host "Missing documented paths : $($MissingDocumentedPaths.Count)"

if ($MissingDocumentedPaths.Count -eq 0) {
    Write-Host "[PASS] All documented repository paths resolve."
}
else {
    Write-Host "[FAIL] Missing documented repository paths:"
    $MissingDocumentedPaths |
        Format-Table Source, Line, Target -AutoSize
}

Write-Section "Git Ignore Protection"

$IgnoreChecks = @(
    'private/test-secret.txt',
    'assets/raw-screenshots/example.png',
    'test.ovpn',
    'test.vmdk',
    'test.pcapng',
    'test.key'
)

$IgnoreFailures = [System.Collections.Generic.List[string]]::new()

foreach ($Item in $IgnoreChecks) {
    git check-ignore -q --no-index $Item

    if ($LASTEXITCODE -eq 0) {
        Write-Host "[PASS] Ignored: $Item"
    }
    else {
        Write-Host "[FAIL] Not ignored: $Item"
        $IgnoreFailures.Add($Item)
    }
}

Write-Section "Result"

$FailureCount = 0

$FailureCount += $ForbiddenFindings.Count
$FailureCount += $SensitiveFindings.Count
$FailureCount += $UnfinishedFindings.Count
$FailureCount += $CRLFFiles.Count
$FailureCount += $LoneCRFiles.Count
$FailureCount += $BrokenLinks.Count
$FailureCount += $MissingDocumentedPaths.Count
$FailureCount += $IgnoreFailures.Count

Write-Host "Forbidden artifacts       : $($ForbiddenFindings.Count)"
Write-Host "Sensitive findings        : $($SensitiveFindings.Count)"
Write-Host "Unfinished markers        : $($UnfinishedFindings.Count)"
Write-Host "CRLF files                : $($CRLFFiles.Count)"
Write-Host "Lone-CR files             : $($LoneCRFiles.Count)"
Write-Host "Broken internal links     : $($BrokenLinks.Count)"
Write-Host "Missing documented paths  : $($MissingDocumentedPaths.Count)"
Write-Host "Git ignore failures       : $($IgnoreFailures.Count)"

if ($FailureCount -eq 0) {
    Write-Host ""
    Write-Host "RESULT: PASS"
    exit 0
}

Write-Host ""
Write-Host "RESULT: FAIL"
exit 1
