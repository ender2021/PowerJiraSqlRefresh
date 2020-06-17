CREATE TABLE [dbo].[tbl_stg_Jira_Issue_Component]
(
[Issue_Id] [int] NOT NULL,
[Component_Id] [int] NOT NULL,
[Refresh_Id] [int] NOT NULL CONSTRAINT [DF_tbl_stg_Jira_Issue_Component_Refresh_Id] DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_stg_Jira_Issue_Component] ADD CONSTRAINT [PK_tbl_Jira_Issue_Component_Staging] PRIMARY KEY CLUSTERED  ([Issue_Id], [Component_Id]) ON [PRIMARY]
GO
GRANT INSERT ON  [dbo].[tbl_stg_Jira_Issue_Component] TO [JiraRefreshRole]
GO
GRANT SELECT ON  [dbo].[tbl_stg_Jira_Issue_Component] TO [JiraRefreshRole]
GO
