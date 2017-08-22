SELECT '<All>' AS OperatingSystemName,
 '%' AS OSValue
UNION
SELECT
 os.Caption0 AS OperatingSystemName,
 os.Caption0 AS OSValue
FROM v_R_System_Valid s 
INNER JOIN v_GS_OPERATING_SYSTEM os 
	ON s.ResourceID = os.ResourceID       
GROUP BY os.Caption0