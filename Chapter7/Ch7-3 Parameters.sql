SELECT s.ResourceID, 
	os.Caption0 AS OperatingSystemName,
	ISNULL(os.CSDVersion0, 'None') AS ServicePack, 
	s.Netbios_Name0 AS ComputerName,
	gs.Model0 AS ComputerModel,
	p.Name0 AS ProcessorName,
	m.TotalPhysicalMemory0 / 1024 AS TotalMemoryMB,
	os.LastBootUpTime0 as LastBootUpTime
FROM v_R_System_Valid s 
	INNER JOIN v_GS_OPERATING_SYSTEM os ON s.ResourceID = os.ResourceID       
	INNER JOIN v_GS_COMPUTER_SYSTEM gs ON s.ResourceID = gs.ResourceID 
	INNER JOIN v_GS_X86_PC_MEMORY m ON s.ResourceID = m.ResourceID
	INNER JOIN v_GS_PROCESSOR p ON s.ResourceID = p.ResourceID