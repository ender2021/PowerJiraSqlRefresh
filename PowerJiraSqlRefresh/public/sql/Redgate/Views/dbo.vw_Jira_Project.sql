SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dbo].[vw_Jira_Project] AS
SELECT [Project_Id]
      ,[Project_Key]
      ,[Project_Name]
      ,[Description]
      ,[Lead_User_Id]
      ,[Lead_User_Name]
      ,[Category_Id]
      ,[Project_Type_Key]
      ,[Simplified]
      ,[Style]
      ,[Private]
      ,[Update_Refresh_Id]
  FROM [dbo].[tbl_Jira_Project]
GO
GRANT SELECT ON  [dbo].[vw_Jira_Project] TO [JiraRefreshRole]
GO
