CREATE TABLE [dbo].[tbl_stg_Jira_Issue_All_Id]
(
[Issue_Id] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_stg_Jira_Issue_All_Id] ADD CONSTRAINT [PK_tbl_stg_Jira_Issue_All_Id] PRIMARY KEY CLUSTERED  ([Issue_Id]) ON [PRIMARY]
GO
GRANT INSERT ON  [dbo].[tbl_stg_Jira_Issue_All_Id] TO [JiraRefreshRole]
GO
GRANT SELECT ON  [dbo].[tbl_stg_Jira_Issue_All_Id] TO [JiraRefreshRole]
GO
