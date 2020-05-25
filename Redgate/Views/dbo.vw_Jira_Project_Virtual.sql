SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dbo].[vw_Jira_Project_Virtual]
AS
SELECT * FROM [dbo].[vw_Jira_Project_Small]

UNION ALL

SELECT * FROM [dbo].[tbl_Jira_Project]
GO
GRANT SELECT ON  [dbo].[vw_Jira_Project_Virtual] TO [JiraRefreshRole]
GO
