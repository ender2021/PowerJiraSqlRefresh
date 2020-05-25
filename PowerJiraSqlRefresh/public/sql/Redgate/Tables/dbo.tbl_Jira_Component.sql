CREATE TABLE [dbo].[tbl_Jira_Component]
(
[Component_Id] [int] NOT NULL,
[Project_Key] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Project_Id] [int] NOT NULL,
[Name] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Description] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Lead_User_Id] [char] (43) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Lead_User_Name] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Assignee_Type] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Real_Assignee_Type] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Assignee_Type_Valid] [bit] NOT NULL,
[Update_Refresh_Id] [int] NOT NULL CONSTRAINT [DF_tbl_Jira_Component_Update_Refresh_Id] DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_Jira_Component] ADD CONSTRAINT [PK_tbl_Jira_Component] PRIMARY KEY CLUSTERED  ([Component_Id]) ON [PRIMARY]
GO
