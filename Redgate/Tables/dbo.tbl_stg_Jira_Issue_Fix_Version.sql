CREATE TABLE [dbo].[tbl_stg_Jira_Issue_Fix_Version]
(
[Issue_Id] [int] NOT NULL,
[Version_Id] [int] NOT NULL,
[Refresh_Id] [int] NOT NULL CONSTRAINT [DF_tbl_stg_Jira_Issue_Fix_Version_Refresh_Id] DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_stg_Jira_Issue_Fix_Version] ADD CONSTRAINT [PK_tbl_Jira_Issue_Fix_Version_Staging] PRIMARY KEY CLUSTERED  ([Issue_Id], [Version_Id]) ON [PRIMARY]
GO
GRANT INSERT ON  [dbo].[tbl_stg_Jira_Issue_Fix_Version] TO [JiraRefreshRole]
GO
