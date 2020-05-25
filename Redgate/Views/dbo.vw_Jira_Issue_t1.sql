SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [dbo].[vw_Jira_Issue_t1]
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
	  ,dbo.fn_Jira_Parent_Epic(Issue_Id) AS Parent_Epic_Key
FROM            dbo.tbl_Jira_Issue


GO
