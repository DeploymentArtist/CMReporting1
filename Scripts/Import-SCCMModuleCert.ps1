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

Configuration SCCM
{

    Node localhost
    {
        Script ImportSCCMcert
        {
            Getscript = {
                Write-verbose "In Getscript ImportSCCMcert" 
                $sccmModulePath = "$(Split-Path $env:SMS_ADMIN_UI_PATH -Parent)\ConfigurationManager.psd1"
                $cert = Get-AuthenticodeSignature -FilePath "$sccmModulePath" -ErrorAction SilentlyContinue
                $store = new-object System.Security.Cryptography.X509Certificates.X509Store("TrustedPublisher","LocalMachine")
                $store.Open("MaxAllowed")
                $return = ""
                $return = $store.Certificates | where {$_.thumbprint -eq $cert.SignerCertificate.Thumbprint}
                $store.Close()
                @{Result=$return.ToString()}
            }

            TestScript = {
                    Write-verbose "In TestScript ImportSCCMcert"
                    $sccmModulePath = "$(Split-Path $env:SMS_ADMIN_UI_PATH -Parent)\ConfigurationManager.psd1"
                    $cert = Get-AuthenticodeSignature -FilePath "$sccmModulePath" -ErrorAction SilentlyContinue
                    $store = new-object System.Security.Cryptography.X509Certificates.X509Store("TrustedPublisher","LocalMachine")
                    $store.Open("MaxAllowed")
                    $return = $null
                    $return = $store.Certificates | where {$_.thumbprint -eq $cert.SignerCertificate.Thumbprint}
                    $store.Close()
                    if($return)
                    {
                        write-verbose "Return TRUE"
                        $true
                    }
                    else
                    {
                        write-verbose "Return FALSE"
                        $false
                    }
            }

            SetScript = {
                    Write-verbose "In SetScript ImportSCCMcert"                    
                    $sccmModulePath = "$(Split-Path $env:SMS_ADMIN_UI_PATH -Parent)\ConfigurationManager.psd1"
                    $cert = Get-AuthenticodeSignature -FilePath "$sccmModulePath" -ErrorAction SilentlyContinue
                    $store = new-object System.Security.Cryptography.X509Certificates.X509Store("TrustedPublisher","LocalMachine")
                    $store.Open("MaxAllowed")
                    Write-Verbose "Adding cert to store"
                    $store.Add($cert.SignerCertificate)
                    $store.Close()
            }            
        }
    }
}



function Import-SCCMmoduleCert
{
<#
.Synopsis
   Imports the signed certificate used in the SCCM module into the certificate store on the local computer
.DESCRIPTION
   Requires administrative privileges to run. Run the function as the user that will have the cert 
   imported. The function accepts no parameters and does not return any output.
.EXAMPLE
   Import-SCCMmoduleCert
.NOTES
    Created by Tore Groneng @ToreGroneng Tore.Groneng@gmail.com

#>
[CmdletBinding()]
[OutputType([int])]
Param()
    
    Write-verbose "Start $($MyInvocation.MyCommand.Name)"
    $sccmModulePath = "$(Split-Path $env:SMS_ADMIN_UI_PATH -Parent)\ConfigurationManager.psd1"

    Write-Verbose "Module path is $sccmModulePath, getting cert"
    $cert = Get-AuthenticodeSignature -FilePath "$sccmModulePath" -ErrorAction SilentlyContinue

    Write-Verbose "Creating a store object for LocalMachine\TrustedPublisher"
    $store = new-object System.Security.Cryptography.X509Certificates.X509Store("TrustedPublisher","LocalMachine")
    $store.Open("MaxAllowed")

    Write-Verbose "Adding cert to store"
    $store.Add($cert.SignerCertificate)
    $store.Close()

    Write-Verbose "Done"
}

Import-SCCMmoduleCert -Verbose