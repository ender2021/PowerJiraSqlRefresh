CREATE TABLE [dbo].[tbl_stg_Jira_Project]
(
[Project_Id] [int] NOT NULL,
[Project_Key] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Project_Name] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_tbl_stg_Jira_Project_Project_Name] DEFAULT (''),
[Description] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Lead_User_Id] [char] (43) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Lead_User_Name] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Category_Id] [int] NULL,
[Project_Type_Key] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Simplified] [bit] NOT NULL,
[Style] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Private] [bit] NOT NULL,
[Refresh_Id] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_stg_Jira_Project] ADD CONSTRAINT [PK_tbl_Jira_Project_Staging] PRIMARY KEY CLUSTERED  ([Project_Id]) ON [PRIMARY]
GO
GRANT INSERT ON  [dbo].[tbl_stg_Jira_Project] TO [JiraRefreshRole]
GO
