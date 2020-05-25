CREATE TABLE [dbo].[tbl_Jira_Version]
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
[Update_Refresh_Id] [int] NOT NULL CONSTRAINT [DF_tbl_Jira_Version_Update_Refresh_Id] DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_Jira_Version] ADD CONSTRAINT [PK_tbl_Jira_Version] PRIMARY KEY CLUSTERED  ([Version_Id]) ON [PRIMARY]
GO
