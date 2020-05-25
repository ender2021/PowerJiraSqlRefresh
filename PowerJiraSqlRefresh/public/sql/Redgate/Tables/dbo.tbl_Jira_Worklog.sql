CREATE TABLE [dbo].[tbl_Jira_Worklog]
(
[Worklog_Id] [int] NOT NULL,
[Issue_Id] [int] NOT NULL,
[Time_Spent] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Time_Spent_Seconds] [int] NOT NULL,
[Start_Date] [datetime] NOT NULL,
[Create_Date] [datetime] NOT NULL,
[Update_Date] [datetime] NOT NULL,
[Create_User_Id] [char] (43) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Create_User_Name] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Update_User_Id] [char] (43) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Update_User_Name] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Comment] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Update_Refresh_Id] [int] NOT NULL CONSTRAINT [DF_tbl_Jira_Worklogs_Update_Refresh_Id] DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_Jira_Worklog] ADD CONSTRAINT [PK_tbl_Jira_Worklogs] PRIMARY KEY CLUSTERED  ([Worklog_Id]) ON [PRIMARY]
GO
