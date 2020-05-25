CREATE TABLE [dbo].[tbl_lk_Jira_Refresh_Type]
(
[Refresh_Type_Code] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Refresh_Type] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_lk_Jira_Refresh_Type] ADD CONSTRAINT [PK_tbl_lk_Jira_Refresh_Type] PRIMARY KEY CLUSTERED  ([Refresh_Type_Code]) ON [PRIMARY]
GO
