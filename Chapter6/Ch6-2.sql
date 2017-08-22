SELECT  sys.Netbios_Name0 AS ComputerName,
	sys.Resource_Domain_OR_Workgr0 AS Domain,
	sys.User_Name0 AS UserName, 
    os.Caption0 AS OperatingSystem,
	os.CSDVersion0 AS ServicePack,
	sys.AD_Site_Name0 AS ADSiteName		
FROM v_R_system_Valid  sys  
INNER JOIN v_GS_OPERATING_SYSTEM os 
	ON os.ResourceID = sys.ResourceID
ORDER BY sys.Netbios_Name0

 
