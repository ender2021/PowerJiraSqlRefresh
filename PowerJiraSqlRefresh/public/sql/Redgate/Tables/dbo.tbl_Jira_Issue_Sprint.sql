CREATE TABLE [dbo].[tbl_Jira_Issue_Sprint]
(
[Sprint_Id] [int] NOT NULL,
[Issue_Id] [int] NOT NULL,
[Update_Refresh_Id] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_Jira_Issue_Sprint] ADD CONSTRAINT [PK_tbl_Jira_Issue_Sprint] PRIMARY KEY CLUSTERED  ([Sprint_Id], [Issue_Id]) ON [PRIMARY]
GO
