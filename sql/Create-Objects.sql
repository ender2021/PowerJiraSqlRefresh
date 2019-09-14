/*

Script created by SQL Compare version 13.1.1.5299 from Red Gate Software Ltd at 9/13/2019 9:45:53 PM

*/
SET NUMERIC_ROUNDABORT OFF
GO
SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT, QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
SET XACT_ABORT ON
GO
SET TRANSACTION ISOLATION LEVEL Read committed
GO
BEGIN TRANSACTION
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[tbl_Jira_Refresh]'
GO
CREATE TABLE [dbo].[tbl_Jira_Refresh]
(
[Refresh_ID] [int] NOT NULL IDENTITY(1, 1),
[Refresh_Start] [datetime] NOT NULL,
[Refresh_Start_Unix] [int] NOT NULL,
[Refresh_End] [datetime] NULL,
[Refresh_End_Unix] [int] NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_tbl_Jira_Refresh] on [dbo].[tbl_Jira_Refresh]'
GO
ALTER TABLE [dbo].[tbl_Jira_Refresh] ADD CONSTRAINT [PK_tbl_Jira_Refresh] PRIMARY KEY CLUSTERED  ([Refresh_ID])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[usp_Jira_Get_Max_Refresh]'
GO
-- =============================================
-- Author:		Justin Mead
-- Create date: 2019-09-12
-- Description:	Get the most recent jira refresh record
-- =============================================
CREATE PROCEDURE [dbo].[usp_Jira_Get_Max_Refresh]
	AS
BEGIN
	SET NOCOUNT ON;

	SELECT TOP 1
		   [Refresh_ID]
		  ,[Refresh_Start]
		  ,[Refresh_Start_Unix]
	FROM [dbo].[tbl_Jira_Refresh]
	ORDER BY [Refresh_Start] DESC
END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[usp_Jira_Update_Refresh_End]'
GO
-- =============================================
-- Author:		Justin Mead
-- Create date: 2019-09-12
-- Description:	Sets the end time of a Jira refresh
-- =============================================
CREATE PROCEDURE [dbo].[usp_Jira_Update_Refresh_End]
	@Refresh_Id AS INT
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @currDate AS DATETIME = GETDATE()
    
	UPDATE [dbo].[tbl_Jira_Refresh]
	SET [Refresh_End] = @currDate
	   ,[Refresh_End_Unix] = DATEDIFF(s, '1970-01-01', @currDate)
	WHERE [Refresh_ID] = @Refresh_Id
END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[tbl_Jira_Worklogs]'
GO
CREATE TABLE [dbo].[tbl_Jira_Worklogs]
(
[Worklog_Id] [int] NOT NULL,
[Issue_Id] [int] NOT NULL,
[Time_Spent] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Time_Spent_Seconds] [int] NOT NULL,
[Start_Date] [datetime] NOT NULL,
[Create_Date] [datetime] NOT NULL,
[Update_Date] [datetime] NOT NULL,
[Create_User_Id] [char] (43) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Create_User_Name] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Update_User_Id] [char] (43) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Update_User_Name] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Comment] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Refresh_Id] [int] NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_tbl_Jira_Worklogs] on [dbo].[tbl_Jira_Worklogs]'
GO
ALTER TABLE [dbo].[tbl_Jira_Worklogs] ADD CONSTRAINT [PK_tbl_Jira_Worklogs] PRIMARY KEY CLUSTERED  ([Worklog_Id], [Refresh_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[vw_Jira_Worklog_Max_Refresh]'
GO
CREATE VIEW [dbo].[vw_Jira_Worklog_Max_Refresh]
AS
WITH Max_Refresh(Worklog_Id, Refresh_Id) AS (SELECT        Worklog_Id, MAX(Refresh_Id) AS Expr1
                                                                                                         FROM            dbo.tbl_Jira_Worklogs
                                                                                                         GROUP BY Worklog_Id)
    SELECT        tbl_Jira_Worklogs_1.Worklog_Id, tbl_Jira_Worklogs_1.Issue_Id, tbl_Jira_Worklogs_1.Time_Spent, tbl_Jira_Worklogs_1.Time_Spent_Seconds, tbl_Jira_Worklogs_1.Start_Date, tbl_Jira_Worklogs_1.Create_Date, 
                              tbl_Jira_Worklogs_1.Update_Date, tbl_Jira_Worklogs_1.Create_User_Id, tbl_Jira_Worklogs_1.Create_User_Name, tbl_Jira_Worklogs_1.Update_User_Id, tbl_Jira_Worklogs_1.Update_User_Name, 
                              tbl_Jira_Worklogs_1.Comment, tbl_Jira_Worklogs_1.Refresh_Id
     FROM            dbo.tbl_Jira_Worklogs AS tbl_Jira_Worklogs_1 INNER JOIN
                              Max_Refresh AS Max_Refresh_1 ON Max_Refresh_1.Worklog_Id = tbl_Jira_Worklogs_1.Worklog_Id AND Max_Refresh_1.Refresh_Id = tbl_Jira_Worklogs_1.Refresh_Id
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[tbl_Jira_Component]'
GO
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
[realAssigneeType] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Assignee_Type_Valid] [bit] NOT NULL,
[Refresh_Id] [int] NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_tbl_Jira_Component] on [dbo].[tbl_Jira_Component]'
GO
ALTER TABLE [dbo].[tbl_Jira_Component] ADD CONSTRAINT [PK_tbl_Jira_Component] PRIMARY KEY CLUSTERED  ([Component_Id], [Refresh_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[tbl_Jira_Issue]'
GO
CREATE TABLE [dbo].[tbl_Jira_Issue]
(
[Issue_Id] [int] NOT NULL,
[Issue_Key] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Issue_Type_Id] [int] NOT NULL,
[Project_Id] [int] NOT NULL,
[Project_Key] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
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
[External_Reporter_Name] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[External_Reporter_Email] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[External_Reporter_Department] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Desired_Date] [datetime] NULL,
[Chart_Date_Of_First_Response] [datetime] NULL,
[Start_Date] [datetime] NULL,
[Story_Points] [int] NULL,
[Epic_Key] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Resolution_Id] [int] NULL,
[Priority_Id] [int] NOT NULL,
[Assignee_User_Id] [char] (43) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Assignee_User_Name] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Status_Id] [int] NOT NULL,
[Creator_User_Id] [char] (43) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Creator_User_Name] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Reporter_User_Id] [char] (43) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Reporter_User_Name] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Votes] [int] NULL,
[Parent_Id] [int] NULL,
[Parent_Key] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Refresh_Id] [int] NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_tbl_Jira_Issue] on [dbo].[tbl_Jira_Issue]'
GO
ALTER TABLE [dbo].[tbl_Jira_Issue] ADD CONSTRAINT [PK_tbl_Jira_Issue] PRIMARY KEY CLUSTERED  ([Issue_Id], [Refresh_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[tbl_Jira_Issue_Component]'
GO
CREATE TABLE [dbo].[tbl_Jira_Issue_Component]
(
[Issue_Id] [int] NOT NULL,
[Component_Id] [int] NOT NULL,
[Refresh_Id] [int] NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_tbl_Jira_Issue_Component] on [dbo].[tbl_Jira_Issue_Component]'
GO
ALTER TABLE [dbo].[tbl_Jira_Issue_Component] ADD CONSTRAINT [PK_tbl_Jira_Issue_Component] PRIMARY KEY CLUSTERED  ([Issue_Id], [Component_Id], [Refresh_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[tbl_Jira_Issue_Fix_Version]'
GO
CREATE TABLE [dbo].[tbl_Jira_Issue_Fix_Version]
(
[Issue_Id] [int] NOT NULL,
[Version_Id] [int] NOT NULL,
[Refresh_Id] [int] NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_tbl_Jira_Issue_Fix_Version] on [dbo].[tbl_Jira_Issue_Fix_Version]'
GO
ALTER TABLE [dbo].[tbl_Jira_Issue_Fix_Version] ADD CONSTRAINT [PK_tbl_Jira_Issue_Fix_Version] PRIMARY KEY CLUSTERED  ([Issue_Id], [Refresh_Id], [Version_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[tbl_Jira_Issue_Sprint]'
GO
CREATE TABLE [dbo].[tbl_Jira_Issue_Sprint]
(
[Sprint_Id] [int] NOT NULL,
[Issue_Id] [int] NOT NULL,
[Refresh_Id] [int] NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_tbl_Jira_Issue_Sprint] on [dbo].[tbl_Jira_Issue_Sprint]'
GO
ALTER TABLE [dbo].[tbl_Jira_Issue_Sprint] ADD CONSTRAINT [PK_tbl_Jira_Issue_Sprint] PRIMARY KEY CLUSTERED  ([Sprint_Id], [Issue_Id], [Refresh_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[tbl_Jira_Project]'
GO
CREATE TABLE [dbo].[tbl_Jira_Project]
(
[Project_Id] [int] NOT NULL,
[Project_Key] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Description] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Lead_User_Id] [char] (43) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Lead_User_Name] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Category_Id] [int] NULL,
[Project_Type_Key] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Simplified] [bit] NOT NULL,
[Style] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Private] [bit] NOT NULL,
[Refresh_Id] [int] NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_tbl_Jira_Project] on [dbo].[tbl_Jira_Project]'
GO
ALTER TABLE [dbo].[tbl_Jira_Project] ADD CONSTRAINT [PK_tbl_Jira_Project] PRIMARY KEY CLUSTERED  ([Project_Id], [Refresh_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[tbl_Jira_Project_Category]'
GO
CREATE TABLE [dbo].[tbl_Jira_Project_Category]
(
[Project_Category_Id] [int] NOT NULL,
[Name] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Description] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Refresh_Id] [int] NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_tbl_Jira_Project_Category] on [dbo].[tbl_Jira_Project_Category]'
GO
ALTER TABLE [dbo].[tbl_Jira_Project_Category] ADD CONSTRAINT [PK_tbl_Jira_Project_Category] PRIMARY KEY CLUSTERED  ([Project_Category_Id], [Refresh_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[tbl_Jira_Sprint]'
GO
CREATE TABLE [dbo].[tbl_Jira_Sprint]
(
[Sprint_Id] [int] NOT NULL,
[Rapid_View_Id] [int] NOT NULL,
[State] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Name] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Goal] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Start_Date] [datetime] NOT NULL,
[End_Date] [datetime] NOT NULL,
[Complete_Date] [datetime] NULL,
[Sequence] [int] NOT NULL,
[Refresh_Id] [int] NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_tbl_Jira_Sprint] on [dbo].[tbl_Jira_Sprint]'
GO
ALTER TABLE [dbo].[tbl_Jira_Sprint] ADD CONSTRAINT [PK_tbl_Jira_Sprint] PRIMARY KEY CLUSTERED  ([Sprint_Id], [Refresh_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[tbl_Jira_Version]'
GO
CREATE TABLE [dbo].[tbl_Jira_Version]
(
[Version_Id] [int] NULL,
[Project_Id] [int] NULL,
[Name] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Archived] [bit] NULL,
[Released] [bit] NULL,
[Start_Date] [sql_variant] NULL,
[Release_Date] [datetime2] NULL,
[User_Start_Date] [sql_variant] NULL,
[User_Release_Date] [datetime2] NULL,
[Refresh_Id] [int] NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating extended properties'
GO
BEGIN TRY
	EXEC sp_addextendedproperty N'MS_DiagramPane1', N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "tbl_Jira_Worklogs_1"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 237
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Max_Refresh_1"
            Begin Extent = 
               Top = 6
               Left = 275
               Bottom = 102
               Right = 445
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
', 'SCHEMA', N'dbo', 'VIEW', N'vw_Jira_Worklog_Max_Refresh', NULL, NULL
END TRY
BEGIN CATCH
	DECLARE @msg nvarchar(max);
	DECLARE @severity int;
	DECLARE @state int;
	SELECT @msg = ERROR_MESSAGE(), @severity = ERROR_SEVERITY(), @state = ERROR_STATE();
	RAISERROR(@msg, @severity, @state);

	SET NOEXEC ON
END CATCH
GO
BEGIN TRY
	DECLARE @xp int
SELECT @xp=1
EXEC sp_addextendedproperty N'MS_DiagramPaneCount', @xp, 'SCHEMA', N'dbo', 'VIEW', N'vw_Jira_Worklog_Max_Refresh', NULL, NULL
END TRY
BEGIN CATCH
	DECLARE @msg nvarchar(max);
	DECLARE @severity int;
	DECLARE @state int;
	SELECT @msg = ERROR_MESSAGE(), @severity = ERROR_SEVERITY(), @state = ERROR_STATE();
	RAISERROR(@msg, @severity, @state);

	SET NOEXEC ON
END CATCH
GO
COMMIT TRANSACTION
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
-- This statement writes to the SQL Server Log so SQL Monitor can show this deployment.
IF HAS_PERMS_BY_NAME(N'sys.xp_logevent', N'OBJECT', N'EXECUTE') = 1
BEGIN
    DECLARE @databaseName AS nvarchar(2048), @eventMessage AS nvarchar(2048)
    SET @databaseName = REPLACE(REPLACE(DB_NAME(), N'\', N'\\'), N'"', N'\"')
    SET @eventMessage = N'Redgate SQL Compare: { "deployment": { "description": "Redgate SQL Compare deployed to ' + @databaseName + N'", "database": "' + @databaseName + N'" }}'
    EXECUTE sys.xp_logevent 55000, @eventMessage
END
GO
DECLARE @Success AS BIT
SET @Success = 1
SET NOEXEC OFF
IF (@Success = 1) PRINT 'The database update succeeded'
ELSE BEGIN
	IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION
	PRINT 'The database update failed'
END
GO
