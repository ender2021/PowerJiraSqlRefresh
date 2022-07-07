CREATE TABLE [dbo].[tbl_stg_Jira_Issue]
(
[Issue_Id] [int] NOT NULL,
[Issue_Key] [varchar] (260) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Issue_Type_Id] [int] NOT NULL,
[Project_Id] [int] NOT NULL,
[Project_Key] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Time_Spent] [int] NULL,
[Aggregate_Time_Spent] [int] NULL,
[Resolution_Date] [datetime] NULL,
[Work_Ratio] [bigint] NULL,
[Created_Date] [datetime] NOT NULL,
[Time_Estimate] [int] NULL,
[Aggregate_Time_Original_Estimate] [int] NULL,
[Updated_Date] [datetime] NOT NULL,
[Time_Original_Estimate] [int] NULL,
[Description] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Aggregate_Time_Estimate] [int] NULL,
[Summary] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Due_Date] [datetime] NULL,
[Flagged] [bit] NOT NULL,
[External_Reporter_Name] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[External_Reporter_Email] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[External_Reporter_Department] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Desired_Date] [datetime] NULL,
[Chart_Date_Of_First_Response] [datetime] NULL,
[Start_Date] [datetime] NULL,
[Story_Points] [int] NULL,
[Epic_Key] [varchar] (260) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Resolution_Id] [int] NULL,
[Priority_Id] [int] NULL,
[Assignee_User_Id] [char] (43) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Assignee_User_Name] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Status_Id] [int] NOT NULL,
[Creator_User_Id] [char] (43) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Creator_User_Name] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Reporter_User_Id] [char] (43) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Reporter_User_Name] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Votes] [int] NULL,
[Parent_Id] [int] NULL,
[Parent_Key] [varchar] (260) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Epic_Name] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Activity_Category] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Refresh_Id] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_stg_Jira_Issue] ADD CONSTRAINT [PK_tbl_Jira_Issue_Staging] PRIMARY KEY CLUSTERED  ([Issue_Id]) ON [PRIMARY]
GO
GRANT INSERT ON  [dbo].[tbl_stg_Jira_Issue] TO [JiraRefreshRole]
GO
GRANT SELECT ON  [dbo].[tbl_stg_Jira_Issue] TO [JiraRefreshRole]
GO
