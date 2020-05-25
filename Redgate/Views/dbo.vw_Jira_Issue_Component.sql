SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dbo].[vw_Jira_Issue_Component] AS
SELECT [Issue_Id]
      ,[Component_Id]
      ,[Update_Refresh_Id]
  FROM [dbo].[tbl_Jira_Issue_Component]
GO
GRANT SELECT ON  [dbo].[vw_Jira_Issue_Component] TO [JiraRefreshRole]
GO
