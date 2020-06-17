CREATE TABLE [dbo].[tbl_stg_Jira_Priority]
(
[Priority_Id] [int] NOT NULL,
[Name] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Description] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Icon_Url] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Status_Color] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Refresh_Id] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_stg_Jira_Priority] ADD CONSTRAINT [PK_tbl_stg_Jira_Priority] PRIMARY KEY CLUSTERED  ([Priority_Id]) ON [PRIMARY]
GO
GRANT INSERT ON  [dbo].[tbl_stg_Jira_Priority] TO [JiraRefreshRole]
GO
GRANT SELECT ON  [dbo].[tbl_stg_Jira_Priority] TO [JiraRefreshRole]
GO
