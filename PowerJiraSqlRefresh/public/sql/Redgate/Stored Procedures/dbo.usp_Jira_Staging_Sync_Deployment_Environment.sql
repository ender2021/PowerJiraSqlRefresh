SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author:		Reuben Unruh
-- Create date: 2020-05-18
-- Description:	Synchronize the target Jira staging table to its production counterpart
-- =============================================
CREATE PROCEDURE [dbo].[usp_Jira_Staging_Sync_Deployment_Environment]
AS
BEGIN
    DELETE FROM	[dbo].[tbl_Jira_Deployment_Environment]
	WHERE [Environment_Id] IN (SELECT DISTINCT [Environment_Id] FROM [dbo].[tbl_stg_Jira_Deployment_Environment])

	INSERT INTO [dbo].[tbl_Jira_Deployment_Environment]
	(
	    [Environment_Id],
	    [Environment_Type],
	    [Display_Name],
	    [Update_Refresh_Id]
	)
	SELECT [Environment_Id],
		[Environment_Type],
		[Display_Name],
		[Refresh_Id]
	FROM [dbo].[tbl_stg_Jira_Deployment_Environment]
END

GO
GRANT EXECUTE ON  [dbo].[usp_Jira_Staging_Sync_Deployment_Environment] TO [JiraRefreshRole]
GO
