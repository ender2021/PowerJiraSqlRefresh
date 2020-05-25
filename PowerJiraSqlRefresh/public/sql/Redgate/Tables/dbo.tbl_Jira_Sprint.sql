CREATE TABLE [dbo].[tbl_Jira_Sprint]
(
[Sprint_Id] [int] NOT NULL,
[Rapid_View_Id] [int] NOT NULL,
[State] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Name] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Goal] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Start_Date] [datetime] NULL,
[End_Date] [datetime] NULL,
[Complete_Date] [datetime] NULL,
[Sequence] [int] NOT NULL,
[Update_Refresh_Id] [int] NOT NULL CONSTRAINT [DF_tbl_Jira_Sprint_Update_Refresh_Id] DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_Jira_Sprint] ADD CONSTRAINT [PK_tbl_Jira_Sprint] PRIMARY KEY CLUSTERED  ([Sprint_Id]) ON [PRIMARY]
GO
