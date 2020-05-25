CREATE TABLE [dbo].[tbl_Jira_Issue_Deployment]
(
[Issue_Id] [int] NOT NULL,
[Deployment_Url] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Update_Refresh_Id] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_Jira_Issue_Deployment] ADD CONSTRAINT [PK_tbl_Jira_Issue_Deployment] PRIMARY KEY CLUSTERED  ([Issue_Id], [Deployment_Url]) ON [PRIMARY]
GO
