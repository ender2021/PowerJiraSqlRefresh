SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dbo].[vw_Jira_Issue_Link_Type] AS
SELECT [Issue_Link_Type_Id]
      ,[Name]
      ,[Inward_Label]
      ,[Outward_Label]
      ,[Update_Refresh_Id]
  FROM [dbo].[tbl_Jira_Issue_Link_Type]
GO
GRANT SELECT ON  [dbo].[vw_Jira_Issue_Link_Type] TO [JiraRefreshRole]
GO
