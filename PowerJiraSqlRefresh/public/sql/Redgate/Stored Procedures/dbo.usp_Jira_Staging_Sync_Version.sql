SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Justin Mead
-- Create date: 2019-09-19
-- Description:	Synchronize the target Jira staging table to its production counterpart
-- =============================================
CREATE PROCEDURE [dbo].[usp_Jira_Staging_Sync_Version]
AS
BEGIN
    DELETE FROM [dbo].[tbl_Jira_Version]
	WHERE [Project_Id] IN (SELECT DISTINCT [Project_Id] FROM [dbo].[tbl_stg_Jira_Project])

	INSERT INTO [dbo].[tbl_Jira_Version]
	(
	    [Version_Id],
	    [Project_Id],
	    [Name],
	    [Archived],
	    [Released],
	    [Start_Date],
	    [Release_Date],
	    [User_Start_Date],
	    [User_Release_Date],
	    [Update_Refresh_Id]
	)
	SELECT [Version_Id],
	    [Project_Id],
	    [Name],
	    [Archived],
	    [Released],
	    [Start_Date],
	    [Release_Date],
	    [User_Start_Date],
	    [User_Release_Date],
	    [Refresh_Id]
	FROM [dbo].[tbl_stg_Jira_Version]
END
GO
