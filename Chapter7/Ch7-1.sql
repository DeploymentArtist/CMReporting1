SELECT DISTINCT s.ResourceID, 
	s.Netbios_Name0 AS ComputerName,
	os.Caption0 AS OperatingSystemName,
	os.CSDVersion0 AS ServicePack, 
	pr.Name0 AS ProcessorTypeSpeed, 
	m.TotalPhysicalMemory0 AS TotalMemoryMB, 
	ip.IPAddress0 AS IPAddesses, 
	ld.deviceid0 AS DriveLetter, 
	ld.Size0 AS TotalDriveSizeMMB, 
	ld.freespace0 AS FreeSpaceAvaiableMB
FROM v_R_System_Valid s 
	INNER JOIN v_GS_OPERATING_SYSTEM os ON s.ResourceID = os.ResourceID       
	INNER JOIN v_GS_PROCESSOR pr ON s.ResourceID = pr.ResourceID
	INNER JOIN v_GS_COMPUTER_SYSTEM gs ON s.ResourceID = gs.ResourceID 
	INNER JOIN v_GS_NETWORK_ADAPTER ON s.ResourceID = v_GS_NETWORK_ADAPTER.ResourceID 
	INNER JOIN v_GS_X86_PC_MEMORY m ON s.ResourceID = m.ResourceID
	INNER JOIN v_GS_NETWORK_ADAPTER_CONFIGURATION ip ON s.ResourceID = ip.ResourceID
	INNER JOIN v_GS_LOGICAL_DISK AS ld ON s.ResourceID = ld.ResourceID 
WHERE  ip.IPAddress0 IS NOT NULL AND ip.DefaultIPGateway0 IS NOT NULL
	AND ld.DriveType0=3  
	AND ld.deviceid0='C:'
	AND s.Operating_System_Name_and0 LIKE '%Workstation%'
  
