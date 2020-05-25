SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dbo].[vw_Jira_Issue_Link] AS
SELECT [Issue_Link_Id]
      ,[Link_Type_Id]
      ,[In_Issue_Id]
      ,[In_Issue_Key]
      ,[Out_Issue_Id]
      ,[Out_Issue_Key]
      ,[Update_Refresh_Id]
  FROM [dbo].[tbl_Jira_Issue_Link]
GO
GRANT SELECT ON  [dbo].[vw_Jira_Issue_Link] TO [JiraRefreshRole]
GO
