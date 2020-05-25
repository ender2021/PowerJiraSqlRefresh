SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [dbo].[vw_Jira_Issue]
AS
SELECT [Issue_Id]
      ,[Issue_Key]
      ,[Issue_Type_Id]
      ,[Project_Id]
      ,[Project_Key]
      ,[Time_Spent]
      ,[Aggregate_Time_Spent]
      ,[Resolution_Date]
      ,[Work_Ratio]
      ,[Created_Date]
      ,[Time_Estimate]
      ,[Aggregate_Time_Original_Estimate]
      ,[Updated_Date]
      ,[Time_Original_Estimate]
      ,[Description]
      ,[Aggregate_Time_Estimate]
      ,[Summary]
      ,[Due_Date]
      ,[Flagged]
      ,[External_Reporter_Name]
      ,[External_Reporter_Email]
      ,[External_Reporter_Department]
      ,[Desired_Date]
      ,[Chart_Date_Of_First_Response]
      ,[Start_Date]
      ,[Story_Points]
      ,[Epic_Key]
      ,[Resolution_Id]
      ,[Priority_Id]
      ,[Assignee_User_Id]
      ,[Assignee_User_Name]
      ,[Status_Id]
      ,[Creator_User_Id]
      ,[Creator_User_Name]
      ,[Reporter_User_Id]
      ,[Reporter_User_Name]
      ,[Votes]
      ,[Parent_Id]
      ,[Parent_Key]
      ,[Update_Refresh_Id]
      ,[Parent_Epic_Key]
	  ,[dbo].[fn_Jira_Virtual_Project_Key]([Issue_Id]) AS Virtual_Project_Key
  FROM [Jira].[dbo].[vw_Jira_Issue_t1]


GO
GRANT SELECT ON  [dbo].[vw_Jira_Issue] TO [JiraRefreshRole]
GO
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
         Begin Table = "tbl_Jira_Issue"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 310
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
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
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
', 'SCHEMA', N'dbo', 'VIEW', N'vw_Jira_Issue', NULL, NULL
GO
DECLARE @xp int
SELECT @xp=1
EXEC sp_addextendedproperty N'MS_DiagramPaneCount', @xp, 'SCHEMA', N'dbo', 'VIEW', N'vw_Jira_Issue', NULL, NULL
GO
