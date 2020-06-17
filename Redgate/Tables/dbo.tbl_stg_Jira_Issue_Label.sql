CREATE TABLE [dbo].[tbl_stg_Jira_Issue_Label]
(
[Label] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Issue_Id] [int] NOT NULL,
[Refresh_Id] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_stg_Jira_Issue_Label] ADD CONSTRAINT [PK_tbl_stg_Jira_Issue_Label] PRIMARY KEY CLUSTERED  ([Issue_Id], [Label]) ON [PRIMARY]
GO
GRANT INSERT ON  [dbo].[tbl_stg_Jira_Issue_Label] TO [JiraRefreshRole]
GO
GRANT SELECT ON  [dbo].[tbl_stg_Jira_Issue_Label] TO [JiraRefreshRole]
GO
