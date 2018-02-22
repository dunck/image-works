<# Duncan Kirkland
<# 16/04/17
<# imagefactory.ps1
<#>

<# n   ERRORS
<# 1   Unable to connect to Hyper-V host
<# 2   Unable to connect to MDT host
<# 3   Unable to connect to MDT DeploymentShare
<# 4   Unable to validate given Hyper-V switch name
<#>

.".\configuration.ps1"

$ImageFactoryVMName = "ImageFactory01"

$PSDefaultParameterValues =
@{
    "Test-Connection:Count"      = 1
    "Test-Connection:BufferSize" = 128
}

Function Assert-IFEnvironment()
{
    $Assertions =
    @{
        "HyperVConnectionIsValid" = [boolean]
        (
            Test-Connection $GeneralSettings.HyperVServerFQDN
        )
        "MDTConnectionIsValid" = [boolean]
        (
            Test-Connection $GeneralSettings.MDTServerFQDN
        )
        "DeploymentShareConnectionIsValid" = [boolean]
        (
            Test-Path $GeneralSettings.MDTDeploymentShareUNC
        )
        "HyperVSwitchNameIsValid" = [boolean]
        (
            Get-VMSwitch $VMSettings.General.SwitchName
        )
    }

    If(!($Assertions.HyperVConnectionIsValid))
    {
        Write-Host "Unable to connect to Hyper-V host."
        Write-Host "FQDN given: $($GeneralSettings.HyperVServerFQDN)"

        Exit 1
    }
    Else
    {
        Write-Host "Connection to Hyper-V host is valid."
    }

    If(!($Assertions.MDTConnectionIsValid))
    {
        Write-Host "Unable to connect to MDT host."
        Write-Host "FQDN given: $($GeneralSettings.MDTServerFQDN)"

        Exit 2
    }
    Else
    {
        Write-Host "Connection to MDT host is valid."
    }

    If(!($Assertions.DeploymentShareConnectionIsValid))
    {
        Write-Host "Unable to connect to MDT DeploymentShare."
        Write-Host "UNC given: $($GeneralSettings.MDTDeploymentShareUNC)"

        Exit 3
    }
    Else
    {
        Write-Host "DeploymentShare location is valid."
    }

    If(!($Assertions.HyperVSwitchNameIsValid))
    {
        Write-Host "Unable to validate given Hyper-V switch name."
        Write-Host "Switch given: $($VMSettings.General.SwitchName)"
        Write-Host "Available switches: $((Get-VMSwitch).Name -replace "(.+)","'`$1'" -join ",")"

        Exit 4
    }
    Else
    {
        Write-Host "Hyper-V switch is valid."
    }
}

Function New-IFVM($VMName)
{
    $GeneralSettings = $VMSettings.General

    Try
    {
        Write-Host "Creating new virtual machine."
        New-VM -Name $VMName @GeneralSettings -Verbose
    }
    Catch
    {
        # Add error cases - possible errors include: VM with same name already
        #  existing, "unable to realize" error, invalid switch name, invalid
        #  or inaccessible VHD path
    }
    Finally
    {
        $VMDetails = Get-VM -Name $VMName
        If(!([boolean]($VMDetails)))
        {
            Write-Host "Failed to create virtual machine."
        }
        Else
        {
            Write-Host "Created virtual machine:"
            $VMDetails | Format-List
        }
    }
}

Function Set-IFVM($VMName)
{

}

Function Start-IFVM($VMName)
{

}

Assert-IFEnvironment

New-IFVM $ImageFactoryVMName

Set-IFVM $ImageFactoryVMName

Start-IFVM $ImageFactoryVMName
