CREATE TABLE [dbo].[tbl_stg_Jira_User]
(
[Account_Id] [char] (43) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Account_Type] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DisplayName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Name] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Avatar_16] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Avatar_24] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Avatar_32] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Avatar_48] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Active] [bit] NOT NULL,
[Refresh_Id] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_stg_Jira_User] ADD CONSTRAINT [PK_tbl_stg_Jira_User] PRIMARY KEY CLUSTERED  ([Account_Id]) ON [PRIMARY]
GO
GRANT INSERT ON  [dbo].[tbl_stg_Jira_User] TO [JiraRefreshRole]
GO
GRANT SELECT ON  [dbo].[tbl_stg_Jira_User] TO [JiraRefreshRole]
GO
