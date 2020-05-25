CREATE TABLE [dbo].[tbl_Jira_Issue_Component]
(
[Issue_Id] [int] NOT NULL,
[Component_Id] [int] NOT NULL,
[Update_Refresh_Id] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_Jira_Issue_Component] ADD CONSTRAINT [PK_tbl_Jira_Issue_Component] PRIMARY KEY CLUSTERED  ([Issue_Id], [Component_Id]) ON [PRIMARY]
GO
