CREATE TABLE [dbo].[tbl_Jira_Refresh]
(
[Refresh_ID] [int] NOT NULL IDENTITY(1, 1),
[Refresh_Start] [datetime] NOT NULL,
[Refresh_Start_Unix] [int] NOT NULL,
[Refresh_End] [datetime] NULL,
[Refresh_End_Unix] [int] NULL,
[Type] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_tbl_Jira_Refresh_Type] DEFAULT (' '),
[Status] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_tbl_Jira_Refresh_Status] DEFAULT (' '),
[Deleted] [bit] NOT NULL CONSTRAINT [DF_tbl_Jira_Refresh_Deleted] DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_Jira_Refresh] ADD CONSTRAINT [PK_tbl_Jira_Refresh] PRIMARY KEY CLUSTERED  ([Refresh_ID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_Jira_Refresh] ADD CONSTRAINT [FK_tbl_Jira_Refresh_tbl_lk_Jira_Refresh_Status] FOREIGN KEY ([Status]) REFERENCES [dbo].[tbl_lk_Jira_Refresh_Status] ([Refresh_Status_Code])
GO
