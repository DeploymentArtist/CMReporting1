<#

************************************************************************************************************************

Created:	2015-03-01
Version:	1.1
Homepage:   http://deploymentfundamentals.com

Disclaimer:
This script is provided "AS IS" with no warranties, confers no rights and 
is not supported by the authors or DeploymentArtist.

Author - Johan Arwidmark
    Twitter: @jarwidmark
    Blog   : http://deploymentresearch.com

************************************************************************************************************************

#>

# Check for elevation
If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
    [Security.Principal.WindowsBuiltInRole] "Administrator"))
{
    Write-Warning "Oupps, you need to run this script from an elevated PowerShell prompt!`nPlease start the PowerShell prompt as an Administrator and re-run the script."
	Write-Warning "Aborting script..."
    Break
}

New-Item -Path F:\Sources -ItemType Directory
New-Item -Path F:\Sources\Software -ItemType Directory
New-Item -Path F:\Sources\Software\Adobe -ItemType Directory
New-Item -Path F:\Sources\Software\Microsoft -ItemType Directory
New-Item -Path F:\Sources\Software\CMClient -ItemType Directory
New-Item -Path F:\Sources\Software\CMClient\Install -ItemType Directory
New-Item -Path F:\Sources\Software\CMClient\Hotfixes -ItemType Directory

New-SmbShare –Name Sources –Path "F:\Sources" –FullAccess EVERYONE