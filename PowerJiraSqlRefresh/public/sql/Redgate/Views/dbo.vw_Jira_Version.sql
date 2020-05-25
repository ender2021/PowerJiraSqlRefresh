SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dbo].[vw_Jira_Version] AS
SELECT [Version_Id]
      ,[Project_Id]
      ,[Name]
      ,[Archived]
      ,[Released]
      ,[Start_Date]
      ,[Release_Date]
      ,[User_Start_Date]
      ,[User_Release_Date]
      ,[Update_Refresh_Id]
  FROM [dbo].[tbl_Jira_Version]
GO
GRANT SELECT ON  [dbo].[vw_Jira_Version] TO [JiraRefreshRole]
GO
