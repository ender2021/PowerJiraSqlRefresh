CREATE TABLE [dbo].[tbl_Jira_Resolution]
(
[Resolution_Id] [int] NOT NULL,
[Name] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Description] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Update_Refresh_Id] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_Jira_Resolution] ADD CONSTRAINT [PK_tbl_Jira_Resolution] PRIMARY KEY CLUSTERED  ([Resolution_Id]) ON [PRIMARY]
GO
