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

# Note: PC0001 and PC0002 is still generation 1 (running Windows 7 SP1 is not supported on Generation 2 vms)

$VMLocation = "D:\VMs"
$VMISO = "C:\HydrationCM2012Reporting\ISO\HydrationCM2012Reporting.iso"
$VMNetwork = "Internal"

# Create CM01
$VMName = "BOOK-CM2012Reporting-CM01"
$VMMemory = 16384MB
$VMDiskSize =100GB
New-VM -Name $VMName -Generation 2 -BootDevice CD -MemoryStartupBytes $VMMemory -SwitchName $VMNetwork -Path $VMLocation -NoVHD -Verbose
New-VHD -Path "$VMLocation\$VMName\Virtual Hard Disks\$VMName-Disk1.vhdx" -SizeBytes $VMDiskSize -Verbose
Add-VMHardDiskDrive -VMName $VMName -Path "$VMLocation\$VMName\Virtual Hard Disks\$VMName-Disk1.vhdx" -Verbose
Set-VMProcessor $VMName -Count 4
Set-VMDvdDrive -VMName $VMName -Path $VMISO -Verbose

# Create DC01
$VMName = "BOOK-CM2012Reporting-DC01"
$VMMemory = 2048MB
$VMDiskSize = 100GB
New-VM -Name $VMName -Generation 2 -BootDevice CD -MemoryStartupBytes $VMMemory -SwitchName $VMNetwork -Path $VMLocation -NoVHD -Verbose
New-VHD -Path "$VMLocation\$VMName\Virtual Hard Disks\$VMName-Disk1.vhdx" -SizeBytes $VMDiskSize -Verbose
Add-VMHardDiskDrive -VMName $VMName -Path "$VMLocation\$VMName\Virtual Hard Disks\$VMName-Disk1.vhdx" -Verbose
Set-VMProcessor $VMName -Count 2
Set-VMDvdDrive -VMName $VMName -Path $VMISO -Verbose

# Create PC0001
$VMName = "BOOK-CM2012Reporting-PC0001"
$VMMemory = 2048MB
$VMDiskSize = 60GB
New-VM -Name $VMName -BootDevice CD -MemoryStartupBytes $VMMemory -SwitchName $VMNetwork -Path $VMLocation -NoVHD -Verbose
New-VHD -Path "$VMLocation\$VMName\Virtual Hard Disks\$VMName-Disk1.vhdx" -SizeBytes $VMDiskSize -Verbose
Add-VMHardDiskDrive -VMName $VMName -Path "$VMLocation\$VMName\Virtual Hard Disks\$VMName-Disk1.vhdx" -Verbose
Set-VMProcessor $VMName -Count 2
Set-VMDvdDrive -VMName $VMName -Path $VMISO -Verbose

# Create PC0002
$VMName = "BOOK-CM2012Reporting-PC0002"
$VMMemory = 2048MB
$VMDiskSize = 60GB
New-VM -Name $VMName -BootDevice CD -MemoryStartupBytes $VMMemory -SwitchName $VMNetwork -Path $VMLocation -NoVHD -Verbose
New-VHD -Path "$VMLocation\$VMName\Virtual Hard Disks\$VMName-Disk1.vhdx" -SizeBytes $VMDiskSize -Verbose
Add-VMHardDiskDrive -VMName $VMName -Path "$VMLocation\$VMName\Virtual Hard Disks\$VMName-Disk1.vhdx" -Verbose
Set-VMDvdDrive -VMName $VMName -Path $VMISO -Verbose

# Create PC0003
$VMName = "BOOK-CM2012Reporting-PC0003"
$VMMemory = 2048MB
$VMDiskSize = 60GB
New-VM -Name $VMName -Generation 2 -BootDevice CD -MemoryStartupBytes $VMMemory -SwitchName $VMNetwork -Path $VMLocation -NoVHD -Verbose
New-VHD -Path "$VMLocation\$VMName\Virtual Hard Disks\$VMName-Disk1.vhdx" -SizeBytes $VMDiskSize -Verbose
Add-VMHardDiskDrive -VMName $VMName -Path "$VMLocation\$VMName\Virtual Hard Disks\$VMName-Disk1.vhdx" -Verbose
Set-VMProcessor $VMName -Count 2
Set-VMDvdDrive -VMName $VMName -Path $VMISO -Verbose

# Create PC0004
$VMName = "BOOK-CM2012Reporting-PC0004"
$VMMemory = 2048MB
$VMDiskSize = 60GB
New-VM -Name $VMName -Generation 2 -BootDevice CD -MemoryStartupBytes $VMMemory -SwitchName $VMNetwork -Path $VMLocation -NoVHD -Verbose
New-VHD -Path "$VMLocation\$VMName\Virtual Hard Disks\$VMName-Disk1.vhdx" -SizeBytes $VMDiskSize -Verbose
Add-VMHardDiskDrive -VMName $VMName -Path "$VMLocation\$VMName\Virtual Hard Disks\$VMName-Disk1.vhdx" -Verbose
Set-VMProcessor $VMName -Count 2
Set-VMDvdDrive -VMName $VMName -Path $VMISO -Verbose
