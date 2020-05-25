CREATE TABLE [dbo].[tbl_Jira_Issue_Fix_Version]
(
[Issue_Id] [int] NOT NULL,
[Version_Id] [int] NOT NULL,
[Update_Refresh_Id] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_Jira_Issue_Fix_Version] ADD CONSTRAINT [PK_tbl_Jira_Issue_Fix_Version] PRIMARY KEY CLUSTERED  ([Issue_Id], [Version_Id]) ON [PRIMARY]
GO
