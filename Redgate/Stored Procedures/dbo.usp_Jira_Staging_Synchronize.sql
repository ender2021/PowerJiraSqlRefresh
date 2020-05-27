SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author:		Justin Mead
-- Create date: 2019-09-13
-- Description:	Synchronize staging tables with the live tables
-- =============================================

CREATE PROCEDURE [dbo].[usp_Jira_Staging_Synchronize]
	@Sync_Deleted AS BIT = 1
AS
BEGIN
	SET NOCOUNT ON;

	EXEC [dbo].[usp_Jira_Staging_Sync_Changelog]
	EXEC [dbo].[usp_Jira_Staging_Sync_Component]
	EXEC [dbo].[usp_Jira_Staging_Sync_Deployment]
	EXEC [dbo].[usp_Jira_Staging_Sync_Deployment_Environment]
	EXEC [dbo].[usp_Jira_Staging_Sync_Issue]
	EXEC [dbo].[usp_Jira_Staging_Sync_Issue_Component]
	EXEC [dbo].[usp_Jira_Staging_Sync_Issue_Deployment]
	EXEC [dbo].[usp_Jira_Staging_Sync_Issue_Fix_Version]
	EXEC [dbo].[usp_Jira_Staging_Sync_Issue_Label]
	EXEC [dbo].[usp_Jira_Staging_Sync_Issue_Link]
	EXEC [dbo].[usp_Jira_Staging_Sync_Link_Type]
	EXEC [dbo].[usp_Jira_Staging_Sync_Issue_Sprint]
	EXEC [dbo].[usp_Jira_Staging_Sync_Issue_Type]
	EXEC [dbo].[usp_Jira_Staging_Sync_Priority]
	EXEC [dbo].[usp_Jira_Staging_Sync_Project]
	EXEC [dbo].[usp_Jira_Staging_Sync_Project_Category]
	EXEC [dbo].[usp_Jira_Staging_Sync_Resolution]
	EXEC [dbo].[usp_Jira_Staging_Sync_Sprint]
	EXEC [dbo].[usp_Jira_Staging_Sync_Status]
	EXEC [dbo].[usp_Jira_Staging_Sync_Status_Category]
	EXEC [dbo].[usp_Jira_Staging_Sync_User]
	EXEC [dbo].[usp_Jira_Staging_Sync_Version]
	EXEC [dbo].[usp_Jira_Staging_Sync_Worklog]

	IF @Sync_Deleted = 1 BEGIN EXEC [dbo].[usp_Jira_Staging_Sync_Issue_Deleted] END

END


GO
GRANT EXECUTE ON  [dbo].[usp_Jira_Staging_Synchronize] TO [JiraRefreshRole]
GO
