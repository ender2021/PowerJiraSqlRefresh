SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO









CREATE VIEW [dbo].[vw_Jira_Changelog] AS
SELECT  [Changelog_Id],
	[Author_User_Id],
	[Created_Date],
	[Changelog_Items],
	[Issue_Id],
	[Update_Refresh_Id]
  FROM [dbo].[tbl_Jira_Changelog]








GO
GRANT SELECT ON  [dbo].[vw_Jira_Changelog] TO [JiraRefreshRole]
GO
