SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dbo].[vw_Jira_Issue_Fix_Version] AS
SELECT [Issue_Id]
      ,[Version_Id]
      ,[Update_Refresh_Id]
  FROM [dbo].[tbl_Jira_Issue_Fix_Version]
GO
GRANT SELECT ON  [dbo].[vw_Jira_Issue_Fix_Version] TO [JiraRefreshRole]
GO
