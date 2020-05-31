CREATE TABLE [dbo].[tbl_Jira_Project_Actor]
(
[Actor_Id] [int] NOT NULL,
[Project_Key] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Role_Id] [int] NOT NULL,
[Type] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Actor] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Refresh_Id] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_Jira_Project_Actor] ADD CONSTRAINT [PK_tbl_Jira_Project_Actor] PRIMARY KEY CLUSTERED  ([Actor_Id]) ON [PRIMARY]
GO
