SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dbo].[vw_lk_Jira_Refresh_Status] AS
SELECT [Refresh_Status_Code]
      ,[Refresh_Status]
  FROM [dbo].[tbl_lk_Jira_Refresh_Status]
GO
GRANT SELECT ON  [dbo].[vw_lk_Jira_Refresh_Status] TO [JiraRefreshRole]
GO
