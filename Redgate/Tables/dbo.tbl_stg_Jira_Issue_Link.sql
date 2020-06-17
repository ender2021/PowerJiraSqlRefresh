CREATE TABLE [dbo].[tbl_stg_Jira_Issue_Link]
(
[Issue_Link_Id] [int] NOT NULL,
[Link_Type_Id] [int] NOT NULL,
[In_Issue_Id] [int] NOT NULL,
[In_Issue_Key] [varchar] (300) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Out_Issue_Id] [int] NOT NULL,
[Out_Issue_Key] [varchar] (300) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Refresh_Id] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_stg_Jira_Issue_Link] ADD CONSTRAINT [PK_tbl_stg_Jira_Issue_Link] PRIMARY KEY CLUSTERED  ([Issue_Link_Id]) ON [PRIMARY]
GO
GRANT INSERT ON  [dbo].[tbl_stg_Jira_Issue_Link] TO [JiraRefreshRole]
GO
GRANT SELECT ON  [dbo].[tbl_stg_Jira_Issue_Link] TO [JiraRefreshRole]
GO
