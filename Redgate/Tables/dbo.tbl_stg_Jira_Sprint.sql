CREATE TABLE [dbo].[tbl_stg_Jira_Sprint]
(
[Sprint_Id] [int] NOT NULL,
[Rapid_View_Id] [int] NOT NULL,
[State] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Name] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Goal] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Start_Date] [datetime] NULL,
[End_Date] [datetime] NULL,
[Complete_Date] [datetime] NULL,
[Sequence] [int] NOT NULL,
[Refresh_Id] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_stg_Jira_Sprint] ADD CONSTRAINT [PK_tbl_Jira_Sprint_Staging] PRIMARY KEY CLUSTERED  ([Sprint_Id]) ON [PRIMARY]
GO
GRANT INSERT ON  [dbo].[tbl_stg_Jira_Sprint] TO [JiraRefreshRole]
GO
GRANT SELECT ON  [dbo].[tbl_stg_Jira_Sprint] TO [JiraRefreshRole]
GO
