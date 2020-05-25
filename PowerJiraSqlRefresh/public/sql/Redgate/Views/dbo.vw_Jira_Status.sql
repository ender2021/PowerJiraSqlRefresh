SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dbo].[vw_Jira_Status] AS
SELECT [Status_Id]
      ,[Status_Catgory_Id]
      ,[Name]
      ,[Description]
      ,[Icon_Url]
      ,[Update_Refresh_Id]
  FROM [dbo].[tbl_Jira_Status]
GO
GRANT SELECT ON  [dbo].[vw_Jira_Status] TO [JiraRefreshRole]
GO
