SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [dbo].[vw_Jira_Worklog] AS
SELECT [Worklog_Id],
    [Issue_Id],
    [Time_Spent],
    [Time_Spent_Seconds],
    [Start_Date],
    [Create_Date],
    [Update_Date],
    [Create_User_Id],
    [Create_User_Name],
    [Update_User_Id],
    [Update_User_Name],
    [Comment],
    [Update_Refresh_Id],
	[dbo].[fn_Jira_Epic]([Issue_Id], 'Uncategorized') AS Related_Epic,
	[dbo].[fn_Jira_First_Component]([Issue_Id], 'Uncategorized') AS Related_Component
FROM [dbo].[tbl_Jira_Worklog]


GO
GRANT SELECT ON  [dbo].[vw_Jira_Worklog] TO [JiraRefreshRole]
GO
