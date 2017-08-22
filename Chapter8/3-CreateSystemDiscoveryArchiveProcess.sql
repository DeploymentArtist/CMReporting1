USE [CMMonitor]
GO

/****** Object:  Table [dbo].[SystemDiscoveryArchive]    Script Date: 6/14/2015 2:22:05 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SystemDiscoveryArchive](
	[SystemDiscoveryArchivePK] [INT] IDENTITY(1,1) NOT NULL,
	[ResourceID] [INT] NOT NULL,
	[ResourceType] [INT] NULL,
	[AD_Site_Name0] [NVARCHAR](256) NULL,
	[Client_Type0] [INT] NULL,
	[Client_Version0] [NVARCHAR](256) NULL,
	[CPUType0] [NVARCHAR](256) NULL,
	[Creation_Date0] [DATETIME] NULL,
	[Hardware_ID0] [NVARCHAR](256) NULL,
	[User_Domain0] [NVARCHAR](256) NULL,
	[User_Name0] [NVARCHAR](256) NULL,
	[Netbios_Name0] [NVARCHAR](256) NULL,
	[Operating_System_Name_and0] [NVARCHAR](256) NULL,
	[Resource_Domain_OR_Workgr0] [NVARCHAR](256) NULL,
	[Community_Name0] [NVARCHAR](256) NULL,
	[Is_Virtual_Machine0] [BIT] NULL,
	[Manufacturer] [NVARCHAR](256) NULL,
	[SerialNumber] [NVARCHAR](256) NULL,
	[InsertedDate] [DATETIME] NOT NULL,
	[DeletedDate] [DATETIME] NULL,
 CONSTRAINT [SystemDiscoveryArchivePK] PRIMARY KEY NONCLUSTERED 
(
	[SystemDiscoveryArchivePK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

USE [CMMonitor]
GO

/****** Object:  StoredProcedure [dbo].[SystemDiscoveryArchiveProcess]    Script Date: 6/14/2015 2:52:58 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Steve Thompson
-- Create date: 5/29/2015
-- Description:	Populate and maintain the SystemDiscoveryArchive table.
--
-- =============================================
CREATE PROCEDURE [dbo].[SystemDiscoveryArchiveProcess]
	-- Add the parameters for the stored procedure here
	@CMDBName Varchar(15)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	/*  
	SystemDiscoveryArchive - Insert
	*/  

	Declare @SQL nVarchar(max)
	
	-- Insert all VALID System_DISC records into the archive table
	-- No need for the "ISNULL(Decommissioned0, 0) <> 1" test as the core view for v_r_system already does that
	
	SET @SQL = 'INSERT INTO CMMonitor.dbo.SystemDiscoveryArchive
	(ResourceID, ResourceType, AD_Site_Name0, Client_Type0, Client_Version0, CPUType0, Creation_Date0,
	 Hardware_ID0, User_Domain0, User_Name0, Netbios_Name0, Operating_System_Name_and0, Resource_Domain_OR_Workgr0, 
	 Community_Name0, Is_Virtual_Machine0, Manufacturer, SerialNumber, InsertedDate, DeletedDate)
    SELECT  s.ResourceID, 
            s.ResourceType, 
            s.AD_Site_Name0, 
            s.Client_Type0, 
            s.Client_Version0, 
            s.CPUType0, 
            s.Creation_Date0, 
            s.Hardware_ID0, 
            s.User_Domain0, 
            s.User_Name0, 
            s.Netbios_Name0, 
            s.Operating_System_Name_and0, 
            s.Resource_Domain_OR_Workgr0, 
            s.Community_Name0, 
            s.Is_Virtual_Machine0,
            e.Manufacturer0,
			e.SerialNumber0,
            GETDATE() AS InsertedDate,
            NULL AS DeletedDate            
    FROM ' + @CMDBName + '.dbo.v_R_System s 
     LEFT OUTER JOIN ' + @CMDBName + '.dbo.v_GS_SYSTEM_ENCLOSURE e ON s.ResourceID = e.ResourceID
    WHERE (ISNULL(s.Obsolete0, 0) <> 1 AND s.Client0 = 1)
		AND s.ResourceID NOT IN (SELECT cm.ResourceID FROM CMMonitor.dbo.SystemDiscoveryArchive cm)'
	
	EXEC sp_executesql @SQL	 
	

	/*  
	SystemDiscoveryArchive - Update
	*/  


	-- Set DeletedDate if the data has been removed from the valid system data, 
	--   and DeletedDate has not been previously updated.
	SET @SQL = 'UPDATE CMMonitor.dbo.SystemDiscoveryArchive
		SET DeletedDate = GETDATE()
	WHERE DeletedDate IS NULL  
		AND	ResourceID NOT IN 
	 (SELECT s.ResourceID FROM ' + @CMDBName + '.dbo.v_r_system s)'
	
	--PRINT @SQL
	EXEC  sp_executesql @SQL
	
END

GO

/****** Object:  StoredProcedure [dbo].[usp_SystemDataDetail]    Script Date: 9/4/2015 12:35:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Steve Thompson
-- Create date: 6/10/2013
-- Description:	Drill down report SystemDataDetail
-- =============================================
CREATE PROCEDURE [dbo].[usp_SystemDataDetail]
	-- Add the parameters for the stored procedure here
	@ReportType AS VARCHAR(15),
	@FromDate AS DATETIME,
	@ToDate AS DATETIME
AS
BEGIN
	
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ExcludeDate AS DATETIME

	IF @ReportType = 'Deleted' 
		BEGIN
			SELECT ResourceID
			  ,Netbios_Name0 AS NetbiosName
			  ,AD_Site_Name0 AS ADSiteName
			  ,User_Domain0 AS UserDomain
			  ,User_Name0 AS UserLoginName  
			  ,Operating_System_Name_and0 AS OperatingSystemName
			  ,CPUType0 AS CPUType
			  ,Client_Version0 AS CMClientVersion
				,Manufacturer
				,SerialNumber	
			  ,CONVERT(VARCHAR(25),Creation_Date0, 101) AS CreatedDate
			  ,CONVERT(VARCHAR(25),DeletedDate, 101) AS ActivityDate 
		  FROM CMMonitor.dbo.SystemDiscoveryArchive
		  WHERE DeletedDate IS NOT NULL
			AND CONVERT(VARCHAR(15), DeletedDate, 101) BETWEEN @FromDate AND @ToDate
		END	
	ELSE
		BEGIN
			SELECT ResourceID
			  ,Netbios_Name0 AS NetbiosName
			  ,AD_Site_Name0 AS ADSiteName
			  ,User_Domain0 AS UserDomain
			  ,User_Name0 AS UserLoginName  
			  ,Operating_System_Name_and0 AS OperatingSystemName
			  ,CPUType0 AS CPUType
			  ,Client_Version0 AS CMClientVersion
				,Manufacturer
				,SerialNumber	
			  ,CONVERT(VARCHAR(25),Creation_Date0, 101) AS CreatedDate
			  ,CONVERT(VARCHAR(25),InsertedDate, 101) AS ActivityDate 
		  FROM CMMonitor.dbo.SystemDiscoveryArchive
			WHERE InsertedDate IS NOT NULL
			AND CONVERT(VARCHAR(15), InsertedDate, 101) BETWEEN @FromDate AND @ToDate
		END	
END		


GO
GRANT EXECUTE ON [dbo].[usp_SystemDataDetail] TO [VIAMONSTRA\CM_SR] AS [dbo]
GO