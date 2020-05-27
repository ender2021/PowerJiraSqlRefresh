CREATE TABLE [dbo].[tbl_stg_Jira_Changelog]
(
[Changelog_Id] [int] NOT NULL,
[Author_User_Id] [char] (43) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Created_Date] [datetime] NULL,
[Changelog_Items] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Issue_Id] [int] NOT NULL,
[Refresh_Id] [int] NOT NULL
)
GO
ALTER TABLE [dbo].[tbl_stg_Jira_Changelog] ADD CONSTRAINT [PK_tbl_stg_Jira_Changelog] PRIMARY KEY CLUSTERED  ([Changelog_Id])
GO
GRANT INSERT ON  [dbo].[tbl_stg_Jira_Changelog] TO [JiraRefreshRole]
GO
