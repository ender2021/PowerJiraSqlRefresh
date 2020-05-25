SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author:		Reuben Unruh
-- Create date: 2020-05-18
-- Description:	Synchronize the target Jira staging table to its production counterpart
-- =============================================
CREATE PROCEDURE [dbo].[usp_Jira_Staging_Sync_Issue_Deployment]
AS
BEGIN
    DELETE FROM [dbo].[tbl_Jira_Issue_Deployment]
	WHERE [Issue_Id] IN (SELECT DISTINCT [Issue_Id] FROM [dbo].[tbl_stg_Jira_Issue])

	INSERT INTO [dbo].[tbl_Jira_Issue_Deployment]
	(
	    [Issue_Id],
	    [Deployment_Url],
	    [Update_Refresh_Id]
	)
	SELECT DISTINCT [Issue_Id],
	    [Deployment_Url],
	    [Refresh_Id]
	FROM [dbo].[tbl_stg_Jira_Issue_Deployment]
END

GO
GRANT EXECUTE ON  [dbo].[usp_Jira_Staging_Sync_Issue_Deployment] TO [JiraRefreshRole]
GO
