SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [dbo].[vw_Jira_Issue_Deployment] AS
SELECT [Issue_Id]
      ,[Deployment_Url]
      ,[Update_Refresh_Id]
  FROM [dbo].[tbl_Jira_Issue_Deployment]

GO
GRANT SELECT ON  [dbo].[vw_Jira_Issue_Deployment] TO [JiraRefreshRole]
GO
