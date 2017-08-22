<#

************************************************************************************************************************

Created:	2015-03-01
Version:	1.1
Homepage:    	http://deploymentfundamentals.com

Disclaimer:
This script is provided "AS IS" with no warranties, confers no rights and 
is not supported by the authors or DeploymentArtist.

Author - Johan Arwidmark
    Twitter: @jarwidmark
    Blog   : http://deploymentresearch.com

************************************************************************************************************************

#>

# Check for elevation
Write-Host "Checking for elevation"

If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
    [Security.Principal.WindowsBuiltInRole] "Administrator"))
{
    Write-Output "Oupps, you need to run this script from an elevated PowerShell prompt!`nPlease start the PowerShell prompt as an Administrator and re-run the script."
    Write-Output "Aborting script..."
    Break
}
Else
{
    Write-Output "PowerShell runs elevated, OK, continuing..."
    Write-Output ""
}

$VMName = "CM01"
$VM = Get-VM -Name $VMName

$VMDiskLocation = $VM.Path + "\Virtual Hard Disks"

$VMDisk01 = New-VHD –Path $VMDiskLocation\$VMName-DataDisk01.vhdx -SizeBytes 100GB
$VMDisk02 = New-VHD –Path $VMDiskLocation\$VMName-DataDisk02.vhdx -SizeBytes 300GB
$VMDisk03 = New-VHD –Path $VMDiskLocation\$VMName-DataDisk03.vhdx -SizeBytes 50GB
$VMDisk04 = New-VHD –Path $VMDiskLocation\$VMName-DataDisk04.vhdx -SizeBytes 100GB
$VMDisk05 = New-VHD –Path $VMDiskLocation\$VMName-DataDisk05.vhdx -SizeBytes 75GB

Add-VMHardDiskDrive -VM $VM -Path $VMDisk01.path –ControllerType SCSI -ControllerNumber 0
Add-VMHardDiskDrive -VM $VM -Path $VMDisk02.path –ControllerType SCSI -ControllerNumber 0
Add-VMHardDiskDrive -VM $VM -Path $VMDisk03.path –ControllerType SCSI -ControllerNumber 0
Add-VMHardDiskDrive -VM $VM -Path $VMDisk04.path –ControllerType SCSI -ControllerNumber 0
Add-VMHardDiskDrive -VM $VM -Path $VMDisk05.path –ControllerType SCSI -ControllerNumber 0
