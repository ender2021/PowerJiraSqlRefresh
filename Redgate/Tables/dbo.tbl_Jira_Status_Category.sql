CREATE TABLE [dbo].[tbl_Jira_Status_Category]
(
[Status_Category_Id] [int] NOT NULL,
[Name] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Key] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Color_Name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Update_Refresh_Id] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_Jira_Status_Category] ADD CONSTRAINT [PK_tbl_Jira_Status_Category] PRIMARY KEY CLUSTERED  ([Status_Category_Id]) ON [PRIMARY]
GO
