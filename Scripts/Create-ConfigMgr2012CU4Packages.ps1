$SiteServer = $Env:COMPUTERNAME
 
# Import the ConfigMgr PowerShell module
Import-Module $env:SMS_ADMIN_UI_PATH.Replace("\bin\i386","\bin\configurationmanager.psd1")
$SiteCode = Get-PSDrive -PSProvider CMSITE
Set-Location "$($SiteCode.Name):\"
 
# Create the Configuration Manager Updates folder
New-Item "$($SiteCode):\Package\Configuration Manager Updates"
 
# Create the console update package
$ConsolePackage = New-CMPackage -Name "R2 CU4 - console update - $SiteCode" -Description "R2 CU4 - console update - $SiteCode" -Path "\\$SiteServer\SMS_$SiteCode\hotfix\KB3026739\AdminConsole\i386"
Move-CMObject -FolderPath "$($SiteCode):\Package\Configuration Manager Updates" -InputObject $ConsolePackage
New-CMProgram -PackageName $ConsolePackage.Name -StandardProgramName "Cumulative update 4 - console update install" -CommandLine "msiexec.exe /p configmgr2012adminui-r2-kb3026739-i386.msp /L*v %TEMP%\configmgr2012adminui-r2-kb3026739-i386.msp.LOG /q REBOOT=ReallySuppress REINSTALL=ALL REINSTALLMODE=mous" -ProgramRunType WhetherOrNotUserIsLoggedOn -RunMode RunWithAdministrativeRights -UserInteraction $false
 
# Create the server update package
$ServerPackage = New-CMPackage -Name "R2 CU4 - server update - $SiteCode" -Description "R2 CU4 - server update - $SiteCode" -Path "\\$SiteServer\SMS_$SiteCode\hotfix\KB3026739\Server\x64"
Move-CMObject -FolderPath "$($SiteCode):\Package\Configuration Manager Updates" -InputObject $ServerPackage
New-CMProgram -PackageName $ServerPackage.Name -StandardProgramName "Cumulative update 4 - server update install" -CommandLine "CM12-R2CU4-KB3026739-X64-ENU.exe /Unattended" -ProgramRunType WhetherOrNotUserIsLoggedOn -RunMode RunWithAdministrativeRights -UserInteraction $false
 
# Create the x64 client package
$x64ClientPackage = New-CMPackage -Name "R2 CU4 - x64 client update - $SiteCode" -Description "R2 CU4 - x64 client update - $SiteCode" -Path "\\$SiteServer\SMS_$SiteCode\hotfix\KB3026739\Client\x64"
Move-CMObject -FolderPath "$($SiteCode):\Package\Configuration Manager Updates" -InputObject $x64ClientPackage
New-CMProgram -PackageName $x64ClientPackage.Name -StandardProgramName "Cumulative update 4 - x64 client update install" -CommandLine "msiexec.exe /p configmgr2012ac-r2-kb3026739-x64.msp /L*v %TEMP%\configmgr2012ac-r2-kb3026739-x64.msp.LOG /q REINSTALL=ALL REINSTALLMODE=mous" -ProgramRunType WhetherOrNotUserIsLoggedOn -RunMode RunWithAdministrativeRights -UserInteraction $false
 
# Create the x86 client package
$x86ClientPackage = New-CMPackage -Name "R2 CU4 - x86 client update - $SiteCode" -Description "R2 CU4 - x86 client update - $SiteCode" -Path "\\$SiteServer\SMS_$SiteCode\hotfix\KB3026739\Client\x86"
Move-CMObject -FolderPath "$($SiteCode):\Package\Configuration Manager Updates" -InputObject $x86ClientPackage
New-CMProgram -PackageName $x86ClientPackage.Name -StandardProgramName "Cumulative update 4 - x86 client update install" -CommandLine "msiexec.exe /p configmgr2012ac-r2-kb3026739-i386.msp /L*v %TEMP%\configmgr2012ac-r2-kb3026739-i386.msp.LOG /q REINSTALL=ALL REINSTALLMODE=mous" -ProgramRunType WhetherOrNotUserIsLoggedOn -RunMode RunWithAdministrativeRights -UserInteraction $false