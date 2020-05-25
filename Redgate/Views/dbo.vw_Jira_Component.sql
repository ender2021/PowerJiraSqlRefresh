SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dbo].[vw_Jira_Component] AS
SELECT [Component_Id]
      ,[Project_Key]
      ,[Project_Id]
      ,[Name]
      ,[Description]
      ,[Lead_User_Id]
      ,[Lead_User_Name]
      ,[Assignee_Type]
      ,[Real_Assignee_Type]
      ,[Assignee_Type_Valid]
      ,[Update_Refresh_Id]
  FROM [dbo].[tbl_Jira_Component]
GO
GRANT SELECT ON  [dbo].[vw_Jira_Component] TO [JiraRefreshRole]
GO
