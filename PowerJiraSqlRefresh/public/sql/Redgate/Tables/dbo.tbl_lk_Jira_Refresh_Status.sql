CREATE TABLE [dbo].[tbl_lk_Jira_Refresh_Status]
(
[Refresh_Status_Code] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Refresh_Status] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_lk_Jira_Refresh_Status] ADD CONSTRAINT [PK_tbl_lk_Jira_Refresh_Status] PRIMARY KEY CLUSTERED  ([Refresh_Status_Code]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_lk_Jira_Refresh_Status] ADD CONSTRAINT [FK_tbl_lk_Jira_Refresh_Status_tbl_lk_Jira_Refresh_Status] FOREIGN KEY ([Refresh_Status_Code]) REFERENCES [dbo].[tbl_lk_Jira_Refresh_Status] ([Refresh_Status_Code])
GO
