
' // ************************************************************************************************************************
' // 
' // Created:	2015-03-01
' // Version:	1.1
' // Homepage:    	http://deploymentfundamentals.com
' // 
' // Disclaimer:
' // This script is provided "AS IS" with no warranties, confers no rights and 
' // is not supported by the authors or DeploymentArtist.
' // 
' // Author - Johan Arwidmark
' //     Twitter: @jarwidmark
' //     Blog   : http://deploymentresearch.com
' // 
' // ************************************************************************************************************************/

'Option Explicit 

Const ADS_ACEFLAG_INHERIT_ACE = 2
Const ADS_ACETYPE_ACCESS_ALLOWED = 0

Dim iRetVal 
Dim intRetSts

'On Error Resume Next
iRetVal = ZTIProcess
On Error Goto 0 

Function ZTIProcess() 

	Dim objRootDSE
	Dim objADS
	Dim sComputerName
	Dim sFullComputerName
	Dim bFound
	Dim sPath
	Dim oCN
	Dim oSystem
	Dim oSec
	Dim oACL
	Dim oACE
	Dim o

	'// Build the path to the container
	Set objRootDSE = GetObject("LDAP://RootDSE") 
	sPath = "LDAP://CN=System Management,CN=System," & objRootDSE.Get("defaultNamingContext")

	'// Make sure the container exists.  If not, create it.
	  On Error Resume Next
	  Set oCN = GetObject(sPath)
	  If Err then
	    On Error Goto 0
	    Set oSystem = GetObject("LDAP://CN=System," & objRootDSE.Get("defaultNamingContext"))
	    Set oCN = oSystem.Create("container", "cn=System Management")
	    oCN.SetInfo
	    wscript.echo "Configure AD for ConfigMgr 2012: Created 'System Management' container."
	  End if
	  On Error Goto 0

	  ' Get the ACL of the container
	  Set oSec = oCN.Get("ntSecurityDescriptor")
	  Set oACL = oSec.DiscretionaryAcl

	  ' Build the NT4-style name for the computer
	  sComputerName = "CM01"
	  Set objADS = CreateObject("ADSystemInfo")
	  sFullComputerName = UCase(objADS.DomainShortName & "\" & sComputerName & "$")

	  ' See if the computer is already in the list
	  For each o in oACL
	     If UCase(o.Trustee) = sFullComputerName then
	        bFound = true
	        Exit For
	     End if
	  Next
	  If bFound then
	     wscript.echo "Configure AD for ConfigMgr 2012: " & sFullComputerName & " already has rights."
	     Exit Function
	  End if

	  ' Not present?  Then add it.  Build a new ACE
	  Set oACE = CreateObject("AccessControlEntry") 
	  oACE.AceType = ADS_ACETYPE_ACCESS_ALLOWED 
	  oACE.AccessMask = -1
	  oACE.AceFlags = ADS_ACEFLAG_INHERIT_ACE 
	  oACE.Trustee = sFullComputerName

	  ' Add it to the ACL and apply it to the container
	  oACL.AddAce oACE
	  oSec.DiscretionaryAcl = oACL
	  oCN.Put "ntSecurityDescriptor", Array(oSec)
	  oCN.SetInfo 

	  wscript.echo "Configure AD for ConfigMgr 2012: Successfully granted " & sFullComputerName & " full control access to the System Management container."	

	  ' Cleanup
	  Set oACE = Nothing
	  Set oACL = Nothing
	  Set oSec = Nothing

End Function
