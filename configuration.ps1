<# Duncan Kirkland
<# 19/02/18
<# configuration.ps1
<#>

$XmlConfiguration = [xml](Get-Content ".\configuration.xml") | Select -ExpandProperty "Configuration"

$VMSettings =
@{
    "General" =
    @{
        "NewVHDPath"         = $XmlConfiguration.Environment.VHDXPath
        "BootDevice"         = "CD"
        "NewVHDSizeBytes"    = 64GB  # note: this will create dynamically expanding disk
        "MemoryStartupBytes" = 4GB   # no more than 4GB is necessary when in WinPE
        "Generation"         = 1
        "SwitchName"         = $XmlConfiguration.Network.HyperVSwitchName # consider using an internal-only switch
    }

    "Processor" =
    @{
        "Count"          = 4   # virtual processors
        "Reserve"        = 10  # keep 10% of system resources as reserve for this VM
        "Maximum"        = 75  # only use, at most, 75% of system resources
        "RelativeWeight" = 200 # modify this to your liking
    }

    "NetworkAdapter" =
    @{
        "StaticIPAddress" = $XmlConfiguration.Network.ReservedStaticIP # this needs to be an IP that can reach Microsoft Update, if not using WSUS/similar
    }

    "DVDDrive" =
    @{
        "Path" = $XmlConfiguration.Environment.DeploymentShareUNC + "\Boot\LiteTouchPE_x64.iso"
    }

    "BIOS" =
    @{
        "StartupOrder" = "IDE","CD","Floppy","LegacyNetworkAdapter"
    }

}

$GeneralSettings =
@{
    "HyperVServerFQDN" = $XmlConfiguration.Environment.HyperVServerFQDN
    "MDTServerFQDN" = $XmlConfiguration.Environment.MDTVServerFQDN
    "MDTDeploymentShareUNC" = $XmlConfiguration.Environment.DeploymentShareUNC
}
