SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dbo].[vw_Jira_Priority] AS
SELECT [Priority_Id]
      ,[Name]
      ,[Description]
      ,[Icon_Url]
      ,[Status_Color]
      ,[Update_Refresh_Id]
  FROM [dbo].[tbl_Jira_Priority]
GO
GRANT SELECT ON  [dbo].[vw_Jira_Priority] TO [JiraRefreshRole]
GO
