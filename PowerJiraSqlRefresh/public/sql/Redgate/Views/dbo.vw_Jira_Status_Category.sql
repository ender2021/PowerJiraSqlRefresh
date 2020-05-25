SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dbo].[vw_Jira_Status_Category] AS
SELECT [Status_Category_Id]
      ,[Name]
      ,[Key]
      ,[Color_Name]
      ,[Update_Refresh_Id]
  FROM [dbo].[tbl_Jira_Status_Category]
GO
GRANT SELECT ON  [dbo].[vw_Jira_Status_Category] TO [JiraRefreshRole]
GO
