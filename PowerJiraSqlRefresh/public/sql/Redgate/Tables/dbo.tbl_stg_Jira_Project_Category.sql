CREATE TABLE [dbo].[tbl_stg_Jira_Project_Category]
(
[Project_Category_Id] [int] NOT NULL,
[Name] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Description] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Refresh_Id] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_stg_Jira_Project_Category] ADD CONSTRAINT [PK_tbl_Jira_Project_Category_Staging] PRIMARY KEY CLUSTERED  ([Project_Category_Id]) ON [PRIMARY]
GO
GRANT INSERT ON  [dbo].[tbl_stg_Jira_Project_Category] TO [JiraRefreshRole]
GO
