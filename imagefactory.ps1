<# Duncan Kirkland
<# 16/04/17
<# imagefactory.ps1
<#>

<# n   ERRORS
<# 1   Unable to connect to Hyper-V host
<# 2   Unable to connect to MDT host
<# 3   Unable to connect to MDT DeploymentShare
<#>

.".\configuration.ps1"

$PSDefaultParameterValues =
@{
    "Test-Connection:Count"      = 1
    "Test-Connection:BufferSize" = 128
}

Function Assert-IFEnvironment()
{
    $Assertions = @{
        "HyperVConnection" = [boolean]
        (
            Test-Connection $HyperVServerFQDN
        )
        "MDTConnection" = [boolean]
        (
            Test-Connection $MDTServerFQDN
        )
        "DeploymentShareConnection" = [boolean]
        (
            Test-Path $MDTDeploymentShareUNC
        )
    }

    If(!($Assertions.HyperVConnection))
    {
        Write-Host "Unable to connect to Hyper-V host."
        Write-Host "FQDN given: $HyperVServerFQDN"

        Exit 1
    }

    If(!($Assertions.MDTConnection))
    {
        Write-Host "Unable to connect to MDT host."
        Write-Host "FQDN given: $MDTServerFQDN"

        Exit 2
    }

    If(!($Assertions.DeploymentShareConnection))
    {
        Write-Host "Unable to connect to MDT DeploymentShare."
        Write-Host "UNC given: $DeploymentShareUNC"

        Exit 3
    }
}

Function New-IFVM($VMName)
{

}

Function Set-IFVM($VMName)
{

}

Function Start-IFVM($VMName)
{

}

Assert-IFEnvironment

New-IFVM "ImageFactory01"

Set-IFVM "ImageFactory01"

Start-IFVM "ImageFactory01"
