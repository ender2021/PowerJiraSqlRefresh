SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[vw_Jira_Project_Role] AS 
SELECT [Role_Id],
       [Name],
       [Refresh_Id]
FROM [dbo].[tbl_Jira_Project_Role]
GO
GRANT SELECT ON  [dbo].[vw_Jira_Project_Role] TO [JiraRefreshRole]
GO
