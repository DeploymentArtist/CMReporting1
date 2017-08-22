SELECT s.ResourceID, 
	s.Netbios_Name0 AS ComputerName,
	os.Caption0 AS OperatingSystemName,
	os.CSDVersion0 AS ServicePack, 
	m.TotalPhysicalMemory0 / 1024 AS TotalMemoryMB 
FROM v_R_System_Valid s 
	INNER JOIN v_GS_OPERATING_SYSTEM os ON s.ResourceID = os.ResourceID       
	INNER JOIN v_GS_COMPUTER_SYSTEM gs ON s.ResourceID = gs.ResourceID 
	INNER JOIN v_GS_X86_PC_MEMORY m ON s.ResourceID = m.ResourceID


