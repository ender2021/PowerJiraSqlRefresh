CREATE TABLE [dbo].[tbl_Jira_Project_Category]
(
[Project_Category_Id] [int] NOT NULL,
[Name] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Description] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Update_Refresh_Id] [int] NOT NULL CONSTRAINT [DF_tbl_Jira_Project_Category_Update_Refresh_Id] DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_Jira_Project_Category] ADD CONSTRAINT [PK_tbl_Jira_Project_Category] PRIMARY KEY CLUSTERED  ([Project_Category_Id]) ON [PRIMARY]
GO
