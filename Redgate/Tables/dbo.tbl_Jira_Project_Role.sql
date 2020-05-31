CREATE TABLE [dbo].[tbl_Jira_Project_Role]
(
[Role_Id] [int] NOT NULL,
[Name] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Refresh_Id] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_Jira_Project_Role] ADD CONSTRAINT [PK_tbl_Jira_Project_Role] PRIMARY KEY CLUSTERED  ([Role_Id]) ON [PRIMARY]
GO
