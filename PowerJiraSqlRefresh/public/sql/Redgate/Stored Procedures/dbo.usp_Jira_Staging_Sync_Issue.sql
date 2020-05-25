SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Justin Mead
-- Create date: 2019-09-19
-- Description:	Synchronize the target Jira staging table to its production counterpart
-- =============================================
CREATE PROCEDURE [dbo].[usp_Jira_Staging_Sync_Issue]
AS
BEGIN
    DELETE FROM [dbo].[tbl_Jira_Issue]
	WHERE [Issue_Id] IN (SELECT [Issue_Id] FROM [dbo].[tbl_stg_Jira_Issue])

	INSERT INTO [dbo].[tbl_Jira_Issue]
	(
	    [Issue_Id],
	    [Issue_Key],
	    [Issue_Type_Id],
	    [Project_Id],
	    [Project_Key],
	    [Time_Spent],
	    [Aggregate_Time_Spent],
	    [Resolution_Date],
	    [Work_Ratio],
	    [Created_Date],
	    [Time_Estimate],
	    [Aggregate_Time_Original_Estimate],
	    [Updated_Date],
	    [Time_Original_Estimate],
	    [Description],
	    [Aggregate_Time_Estimate],
	    [Summary],
	    [Due_Date],
	    [Flagged],
	    [External_Reporter_Name],
	    [External_Reporter_Email],
	    [External_Reporter_Department],
	    [Desired_Date],
	    [Chart_Date_Of_First_Response],
	    [Start_Date],
	    [Story_Points],
	    [Epic_Key],
	    [Resolution_Id],
	    [Priority_Id],
	    [Assignee_User_Id],
	    [Assignee_User_Name],
	    [Status_Id],
	    [Creator_User_Id],
	    [Creator_User_Name],
	    [Reporter_User_Id],
	    [Reporter_User_Name],
	    [Votes],
	    [Parent_Id],
	    [Parent_Key],
		[Epic_Name],
	    [Update_Refresh_Id]
	)
	SELECT [Issue_Id],
	    [Issue_Key],
	    [Issue_Type_Id],
	    [Project_Id],
	    [Project_Key],
	    [Time_Spent],
	    [Aggregate_Time_Spent],
	    [Resolution_Date],
	    [Work_Ratio],
	    [Created_Date],
	    [Time_Estimate],
	    [Aggregate_Time_Original_Estimate],
	    [Updated_Date],
	    [Time_Original_Estimate],
	    [Description],
	    [Aggregate_Time_Estimate],
	    [Summary],
	    [Due_Date],
	    [Flagged],
	    [External_Reporter_Name],
	    [External_Reporter_Email],
	    [External_Reporter_Department],
	    [Desired_Date],
	    [Chart_Date_Of_First_Response],
	    [Start_Date],
	    [Story_Points],
	    [Epic_Key],
	    [Resolution_Id],
	    [Priority_Id],
	    [Assignee_User_Id],
	    [Assignee_User_Name],
	    [Status_Id],
	    [Creator_User_Id],
	    [Creator_User_Name],
	    [Reporter_User_Id],
	    [Reporter_User_Name],
	    [Votes],
	    [Parent_Id],
	    [Parent_Key],
		[Epic_Name],
	    [Refresh_Id]
	FROM [dbo].[tbl_stg_Jira_Issue]
END
GO
