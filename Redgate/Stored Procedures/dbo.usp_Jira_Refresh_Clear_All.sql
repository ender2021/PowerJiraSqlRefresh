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

	TRUNCATE TABLE [dbo].[tbl_Jira_Changelog]
	TRUNCATE TABLE [dbo].[tbl_Jira_Component]
	TRUNCATE TABLE [dbo].[tbl_Jira_Issue]
	TRUNCATE TABLE [dbo].[tbl_Jira_Issue_Component]
	TRUNCATE TABLE [dbo].[tbl_Jira_Issue_Fix_Version]
	TRUNCATE TABLE [dbo].[tbl_Jira_Issue_Label]
	TRUNCATE TABLE [dbo].[tbl_Jira_Issue_Link]
	TRUNCATE TABLE [dbo].[tbl_Jira_Issue_Link_Type]
	TRUNCATE TABLE [dbo].[tbl_Jira_Issue_Sprint]
	TRUNCATE TABLE [dbo].[tbl_Jira_Issue_Type]
	TRUNCATE TABLE [dbo].[tbl_Jira_Priority]
	TRUNCATE TABLE [dbo].[tbl_Jira_Project]
	TRUNCATE TABLE [dbo].[tbl_Jira_Project_Category]
	TRUNCATE TABLE [dbo].[tbl_Jira_Resolution]
	TRUNCATE TABLE [dbo].[tbl_Jira_Sprint]
	TRUNCATE TABLE [dbo].[tbl_Jira_Status]
	TRUNCATE TABLE [dbo].[tbl_Jira_Status_Category]
	TRUNCATE TABLE [dbo].[tbl_Jira_User]
	TRUNCATE TABLE [dbo].[tbl_Jira_Version]
	TRUNCATE TABLE [dbo].[tbl_Jira_Worklog]

END




GO
GRANT EXECUTE ON  [dbo].[usp_Jira_Refresh_Clear_All] TO [JiraRefreshRole]
GO
