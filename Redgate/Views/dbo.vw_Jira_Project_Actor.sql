SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[vw_Jira_Project_Actor] AS 
SELECT [Actor_Id],
       [Project_Key],
       [Role_Id],
       [Type],
       [Actor],
       [Refresh_Id]
FROM [dbo].[tbl_stg_Jira_Project_Actor]
GO
GRANT SELECT ON  [dbo].[vw_Jira_Project_Actor] TO [JiraRefreshRole]
GO
