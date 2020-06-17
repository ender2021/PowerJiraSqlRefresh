SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- =============================================
-- Author:		Justin Mead
-- Create date: 2019-09-13
-- Description:	Clears the Jira staging tables
-- =============================================

CREATE PROCEDURE [dbo].[usp_Jira_Staging_Clear]
AS
BEGIN
	SET NOCOUNT ON;

    DELETE FROM [dbo].[tbl_stg_Jira_Changelog]
    DELETE FROM [dbo].[tbl_stg_Jira_Component]
	DELETE FROM [dbo].[tbl_stg_Jira_Issue]
	DELETE FROM [dbo].[tbl_stg_Jira_Issue_All_Id]
	DELETE FROM [dbo].[tbl_stg_Jira_Issue_Component]
	DELETE FROM [dbo].[tbl_stg_Jira_Issue_Fix_Version]
	DELETE FROM [dbo].[tbl_stg_Jira_Issue_Label]
	DELETE FROM [dbo].[tbl_stg_Jira_Issue_Link]
	DELETE FROM [dbo].[tbl_stg_Jira_Issue_Link_Type]
	DELETE FROM [dbo].[tbl_stg_Jira_Issue_Sprint]
	DELETE FROM [dbo].[tbl_stg_Jira_Issue_Type]
	DELETE FROM [dbo].[tbl_stg_Jira_Priority]
	DELETE FROM [dbo].[tbl_stg_Jira_Project]
	DELETE FROM [dbo].[tbl_stg_Jira_Project_Actor]
	DELETE FROM [dbo].[tbl_stg_Jira_Project_Category]
	DELETE FROM [dbo].[tbl_stg_Jira_Project_Role]
	DELETE FROM [dbo].[tbl_stg_Jira_Resolution]
	DELETE FROM [dbo].[tbl_stg_Jira_Sprint]
	DELETE FROM [dbo].[tbl_stg_Jira_Status]
	DELETE FROM [dbo].[tbl_stg_Jira_Status_Category]
	DELETE FROM [dbo].[tbl_stg_Jira_User]
	DELETE FROM [dbo].[tbl_stg_Jira_Version]
	DELETE FROM [dbo].[tbl_stg_Jira_Worklog]
	DELETE FROM [dbo].[tbl_stg_Jira_Worklog_Delete]

END


GO
GRANT EXECUTE ON  [dbo].[usp_Jira_Staging_Clear] TO [JiraRefreshRole]
GO
