SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dbo].[vw_Jira_Issue_Type] AS
SELECT [Issue_Type_Id]
      ,[Name]
      ,[Description]
      ,[Icon_Url]
      ,[Subtask_Type]
      ,[Update_Refresh_Id]
  FROM [dbo].[tbl_Jira_Issue_Type]
GO
GRANT SELECT ON  [dbo].[vw_Jira_Issue_Type] TO [JiraRefreshRole]
GO
