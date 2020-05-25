SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




-- =============================================
-- Author:		Reuben Unruh
-- Create date: 2020-05-18
-- Description:	Synchronize the target Jira staging table to its production counterpart
-- =============================================
CREATE PROCEDURE [dbo].[usp_Jira_Staging_Sync_Deployment]
AS
BEGIN
    DELETE FROM	[dbo].[tbl_Jira_Deployment]
	WHERE [Deployment_Url] IN (SELECT DISTINCT [Deployment_Url] FROM [dbo].[tbl_stg_Jira_Deployment])

	INSERT INTO [dbo].[tbl_Jira_Deployment]
	(
	    
		[Display_Name] ,
		[Deployment_Url],
		[State],
		[Last_Updated],
		[Pipeline_Id],
		[Pipeline_Display_Name],
		[Pipeline_Url],
		[Environment_Id],
	    [Update_Refresh_Id]
	)
	SELECT 
		[Display_Name] ,
		[Deployment_Url],
		[State],
		[Last_Updated],
		[Pipeline_Id],
		[Pipeline_Display_Name],
		[Pipeline_Url],
		[Environment_Id],
	    [Refresh_Id]
	FROM [dbo].[tbl_stg_Jira_Deployment]
END




GO
GRANT EXECUTE ON  [dbo].[usp_Jira_Staging_Sync_Deployment] TO [JiraRefreshRole]
GO
