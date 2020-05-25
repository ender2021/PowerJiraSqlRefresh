SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Justin Mead
-- Create date: 2019-09-19
-- Description:	Synchronize the target Jira staging table to its production counterpart
-- =============================================
CREATE PROCEDURE [dbo].[usp_Jira_Staging_Sync_Project]
AS
BEGIN
    DELETE FROM	[dbo].[tbl_Jira_Project]
	WHERE [Project_Id] IN (SELECT DISTINCT [Project_Id] FROM [dbo].[tbl_stg_Jira_Project])

	INSERT INTO [dbo].[tbl_Jira_Project]
	(
	    [Project_Id],
	    [Project_Key],
		[Project_Name],
	    [Description],
	    [Lead_User_Id],
	    [Lead_User_Name],
	    [Category_Id],
	    [Project_Type_Key],
	    [Simplified],
	    [Style],
	    [Private],
	    [Update_Refresh_Id]
	)
	SELECT [Project_Id],
	    [Project_Key],
		[Project_Name],
	    [Description],
	    [Lead_User_Id],
	    [Lead_User_Name],
	    [Category_Id],
	    [Project_Type_Key],
	    [Simplified],
	    [Style],
	    [Private],
	    [Refresh_Id]
	FROM [dbo].[tbl_stg_Jira_Project]
END
GO
