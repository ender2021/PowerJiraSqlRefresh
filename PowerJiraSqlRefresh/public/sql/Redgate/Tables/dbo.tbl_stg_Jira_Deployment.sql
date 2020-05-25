CREATE TABLE [dbo].[tbl_stg_Jira_Deployment]
(
[Display_Name] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Deployment_Url] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[State] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Last_Updated] [datetime] NULL,
[Pipeline_Id] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Pipeline_Display_Name] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Pipeline_Url] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Environment_Id] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Refresh_Id] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_stg_Jira_Deployment] ADD CONSTRAINT [PK_tbl_stg_Jira_Deployment] PRIMARY KEY CLUSTERED  ([Deployment_Url]) ON [PRIMARY]
GO
GRANT INSERT ON  [dbo].[tbl_stg_Jira_Deployment] TO [JiraRefreshRole]
GO
