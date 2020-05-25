SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dbo].[vw_lk_Jira_Refresh_Type] AS
SELECT [Refresh_Type_Code]
      ,[Refresh_Type]
  FROM [dbo].[tbl_lk_Jira_Refresh_Type]
GO
GRANT SELECT ON  [dbo].[vw_lk_Jira_Refresh_Type] TO [JiraRefreshRole]
GO
