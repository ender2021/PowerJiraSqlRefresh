SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




-- =============================================
-- Author:		Justin Mead
-- Create date: 2019-09-28
-- Description:	Clears all data from the Jira Refresh tables, and sets all batches to deleted (except the baseline record)
-- =============================================

CREATE PROCEDURE [dbo].[usp_Jira_Refresh_Clear_All]
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE [dbo].[tbl_Jira_Refresh]
	SET [Deleted] = 1

	DELETE FROM [dbo].[tbl_Jira_Changelog]
	DELETE FROM [dbo].[tbl_Jira_Component]
	DELETE FROM [dbo].[tbl_Jira_Issue]
	DELETE FROM [dbo].[tbl_Jira_Issue_Component]
	DELETE FROM [dbo].[tbl_Jira_Issue_Fix_Version]
	DELETE FROM [dbo].[tbl_Jira_Issue_Label]
	DELETE FROM [dbo].[tbl_Jira_Issue_Link]
	DELETE FROM [dbo].[tbl_Jira_Issue_Link_Type]
	DELETE FROM [dbo].[tbl_Jira_Issue_Sprint]
	DELETE FROM [dbo].[tbl_Jira_Issue_Type]
	DELETE FROM [dbo].[tbl_Jira_Priority]
	DELETE FROM [dbo].[tbl_Jira_Project]
	DELETE FROM [dbo].[tbl_Jira_Project_Actor]
	DELETE FROM [dbo].[tbl_Jira_Project_Category]
	DELETE FROM [dbo].[tbl_Jira_Project_Role]
	DELETE FROM [dbo].[tbl_Jira_Resolution]
	DELETE FROM [dbo].[tbl_Jira_Sprint]
	DELETE FROM [dbo].[tbl_Jira_Status]
	DELETE FROM [dbo].[tbl_Jira_Status_Category]
	DELETE FROM [dbo].[tbl_Jira_User]
	DELETE FROM [dbo].[tbl_Jira_Version]
	DELETE FROM [dbo].[tbl_Jira_Worklog]

END




GO
GRANT EXECUTE ON  [dbo].[usp_Jira_Refresh_Clear_All] TO [JiraRefreshRole]
GO
