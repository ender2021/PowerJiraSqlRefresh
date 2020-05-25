CREATE TABLE [dbo].[tbl_stg_Jira_Version]
(
[Version_Id] [int] NOT NULL,
[Project_Id] [int] NOT NULL,
[Name] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Archived] [bit] NOT NULL,
[Released] [bit] NOT NULL,
[Start_Date] [datetime] NULL,
[Release_Date] [datetime] NULL,
[User_Start_Date] [datetime] NULL,
[User_Release_Date] [datetime] NULL,
[Refresh_Id] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_stg_Jira_Version] ADD CONSTRAINT [PK_tbl_Jira_Version_Staging] PRIMARY KEY CLUSTERED  ([Version_Id]) ON [PRIMARY]
GO
GRANT INSERT ON  [dbo].[tbl_stg_Jira_Version] TO [JiraRefreshRole]
GO
