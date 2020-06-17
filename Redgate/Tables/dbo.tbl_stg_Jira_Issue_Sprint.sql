CREATE TABLE [dbo].[tbl_stg_Jira_Issue_Sprint]
(
[Sprint_Id] [int] NOT NULL,
[Issue_Id] [int] NOT NULL,
[Refresh_Id] [int] NOT NULL CONSTRAINT [DF_tbl_stg_Jira_Issue_Sprint_Refresh_Id] DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_stg_Jira_Issue_Sprint] ADD CONSTRAINT [PK_tbl_Jira_Issue_Sprint_Staging] PRIMARY KEY CLUSTERED  ([Sprint_Id], [Issue_Id]) ON [PRIMARY]
GO
GRANT INSERT ON  [dbo].[tbl_stg_Jira_Issue_Sprint] TO [JiraRefreshRole]
GO
GRANT SELECT ON  [dbo].[tbl_stg_Jira_Issue_Sprint] TO [JiraRefreshRole]
GO
