SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Justin Mead
-- Create date: 2019-09-19
-- Description:	Synchronize the target Jira staging table to its production counterpart
-- =============================================
CREATE PROCEDURE [dbo].[usp_Jira_Staging_Sync_Component]
AS
BEGIN
    DELETE FROM	[dbo].[tbl_Jira_Component]
	WHERE [Project_Id] IN (SELECT DISTINCT [Project_Id] FROM [dbo].[tbl_stg_Jira_Project])

	INSERT INTO [dbo].[tbl_Jira_Component]
	(
	    [Component_Id],
	    [Project_Key],
	    [Project_Id],
	    [Name],
	    [Description],
	    [Lead_User_Id],
	    [Lead_User_Name],
	    [Assignee_Type],
	    [Real_Assignee_Type],
	    [Assignee_Type_Valid],
	    [Update_Refresh_Id]
	)
	SELECT [Component_Id],
	    [Project_Key],
	    [Project_Id],
	    [Name],
	    [Description],
	    [Lead_User_Id],
	    [Lead_User_Name],
	    [Assignee_Type],
	    [Real_Assignee_Type],
	    [Assignee_Type_Valid],
	    [Refresh_Id]
	FROM [dbo].[tbl_stg_Jira_Component]
END
GO
