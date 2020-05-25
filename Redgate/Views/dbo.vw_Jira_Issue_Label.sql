SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dbo].[vw_Jira_Issue_Label] AS
SELECT [Label]
      ,[Issue_Id]
      ,[Update_Refresh_Id]
  FROM [dbo].[tbl_Jira_Issue_Label]
GO
GRANT SELECT ON  [dbo].[vw_Jira_Issue_Label] TO [JiraRefreshRole]
GO
