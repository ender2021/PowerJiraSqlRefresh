SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dbo].[vw_Jira_Project_Category] AS
SELECT [Project_Category_Id]
      ,[Name]
      ,[Description]
      ,[Update_Refresh_Id]
  FROM [dbo].[tbl_Jira_Project_Category]
GO
GRANT SELECT ON  [dbo].[vw_Jira_Project_Category] TO [JiraRefreshRole]
GO
