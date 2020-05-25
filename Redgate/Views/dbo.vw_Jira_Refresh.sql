SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dbo].[vw_Jira_Refresh]
AS
SELECT [Refresh_ID]
      ,[Refresh_Start]
      ,[Refresh_Start_Unix]
      ,[Refresh_End]
      ,[Refresh_End_Unix]
	  ,CAST(DATEDIFF(SECOND, [Refresh_Start], [Refresh_End]) AS FLOAT) / 60 AS [Duration_Minutes]
      ,[Type]
      ,[Status]
      ,[Deleted]
  FROM [dbo].[tbl_Jira_Refresh]
GO
GRANT SELECT ON  [dbo].[vw_Jira_Refresh] TO [JiraRefreshRole]
GO
