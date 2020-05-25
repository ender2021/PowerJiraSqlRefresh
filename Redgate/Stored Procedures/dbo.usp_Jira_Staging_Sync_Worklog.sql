SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Justin Mead
-- Create date: 2019-09-19
-- Description:	Synchronize the target Jira staging table to its production counterpart
-- =============================================
CREATE PROCEDURE [dbo].[usp_Jira_Staging_Sync_Worklog]
AS
BEGIN
    DELETE FROM [dbo].[tbl_Jira_Worklog]
	WHERE [Worklog_Id] IN (SELECT DISTINCT [Worklog_Id] FROM [dbo].[tbl_stg_Jira_Worklog])

	DELETE FROM [dbo].[tbl_Jira_Worklog]
	WHERE [Worklog_Id] IN (SELECT [Worklog_Id] FROM [dbo].[tbl_stg_Jira_Worklog_Delete])

	INSERT INTO [dbo].[tbl_Jira_Worklog]
	(
	    [Worklog_Id],
	    [Issue_Id],
	    [Time_Spent],
	    [Time_Spent_Seconds],
	    [Start_Date],
	    [Create_Date],
	    [Update_Date],
	    [Create_User_Id],
	    [Create_User_Name],
	    [Update_User_Id],
	    [Update_User_Name],
	    [Comment],
	    [Update_Refresh_Id]
	)
	SELECT [Worklog_Id],
	    [Issue_Id],
	    [Time_Spent],
	    [Time_Spent_Seconds],
	    [Start_Date],
	    [Create_Date],
	    [Update_Date],
	    [Create_User_Id],
	    [Create_User_Name],
	    [Update_User_Id],
	    [Update_User_Name],
	    [Comment],
	    [Refresh_Id]
	FROM [dbo].[tbl_stg_Jira_Worklog]
END
GO
