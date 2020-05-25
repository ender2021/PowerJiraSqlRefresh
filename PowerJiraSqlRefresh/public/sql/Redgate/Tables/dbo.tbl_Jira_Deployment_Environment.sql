CREATE TABLE [dbo].[tbl_Jira_Deployment_Environment]
(
[Environment_Id] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Environment_Type] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Display_Name] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Update_Refresh_Id] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_Jira_Deployment_Environment] ADD CONSTRAINT [PK_tbl_Jira_Deployment_Environment] PRIMARY KEY CLUSTERED  ([Environment_Id]) ON [PRIMARY]
GO
