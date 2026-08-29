@{
    Severity = @(
        'Error'
        'Warning'
    )

    ExcludeRules = @(
        # These scripts intentionally use Write-Host for readable,
        # beginner-facing status output.
        'PSAvoidUsingWriteHost'

        # Repository scripts are procedural setup/validation helpers rather
        # than reusable PowerShell cmdlets. State-changing behavior is
        # documented and validated separately.
        'PSUseShouldProcessForStateChangingFunctions'
    )

    Rules = @{
        PSAvoidUsingPlainTextForPassword = @{
            Enable = $true
        }

        PSAvoidUsingConvertToSecureStringWithPlainText = @{
            Enable = $true
        }

        PSAvoidUsingInvokeExpression = @{
            Enable = $true
        }

        PSAvoidUsingUserNameAndPasswordParams = @{
            Enable = $true
        }
    }
}
