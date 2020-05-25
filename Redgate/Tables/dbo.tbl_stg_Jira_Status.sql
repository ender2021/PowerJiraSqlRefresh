CREATE TABLE [dbo].[tbl_stg_Jira_Status]
(
[Status_Id] [int] NOT NULL,
[Status_Catgory_Id] [int] NOT NULL,
[Name] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Description] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Icon_Url] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Refresh_Id] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_stg_Jira_Status] ADD CONSTRAINT [PK_tbl_stg_Jira_Status] PRIMARY KEY CLUSTERED  ([Status_Id]) ON [PRIMARY]
GO
GRANT INSERT ON  [dbo].[tbl_stg_Jira_Status] TO [JiraRefreshRole]
GO
