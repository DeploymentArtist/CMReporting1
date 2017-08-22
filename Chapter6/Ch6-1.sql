SELECT  sys.Netbios_Name0 AS ComputerName,
	sys.Resource_Domain_OR_Workgr0 AS Domain,
	sys.User_Name0 AS UserName, 
    sys.Operating_system_Name_and0 AS OperatingSystem,
	sys.AD_Site_Name0 AS ADSiteName		
FROM v_R_system_Valid  sys  
ORDER BY sys.Netbios_Name0