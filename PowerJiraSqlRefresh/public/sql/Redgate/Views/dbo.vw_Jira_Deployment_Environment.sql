SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO








CREATE VIEW [dbo].[vw_Jira_Deployment_Environment] AS
SELECT  [Environment_Id],
	[Environment_Type],
	[Display_Name],
	[Update_Refresh_Id]
  FROM [dbo].[tbl_Jira_Deployment_Environment]







GO
GRANT SELECT ON  [dbo].[vw_Jira_Deployment_Environment] TO [JiraRefreshRole]
GO
