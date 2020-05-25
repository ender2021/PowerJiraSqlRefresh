SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO







CREATE VIEW [dbo].[vw_Jira_Deployment] AS
SELECT [Display_Name],
	[Deployment_Url],
	[State],
	[Last_Updated],
	[Pipeline_Id],
	[Pipeline_Display_Name],
	[Pipeline_Url],
	[Environment_Id],
	[Update_Refresh_Id]
  FROM [dbo].[tbl_Jira_Deployment]






GO
GRANT SELECT ON  [dbo].[vw_Jira_Deployment] TO [JiraRefreshRole]
GO
