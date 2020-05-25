SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dbo].[vw_Jira_Resolution] AS
SELECT [Resolution_Id]
      ,[Name]
      ,[Description]
      ,[Update_Refresh_Id]
  FROM [dbo].[tbl_Jira_Resolution]
GO
GRANT SELECT ON  [dbo].[vw_Jira_Resolution] TO [JiraRefreshRole]
GO
