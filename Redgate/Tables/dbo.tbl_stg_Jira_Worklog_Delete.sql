CREATE TABLE [dbo].[tbl_stg_Jira_Worklog_Delete]
(
[Worklog_Id] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_stg_Jira_Worklog_Delete] ADD CONSTRAINT [PK_tbl_stg_Jira_Worklog_Delete] PRIMARY KEY CLUSTERED  ([Worklog_Id]) ON [PRIMARY]
GO
GRANT INSERT ON  [dbo].[tbl_stg_Jira_Worklog_Delete] TO [JiraRefreshRole]
GO
