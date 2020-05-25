SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Justin Mead
-- Create date: 2019-09-19
-- Description:	Synchronize the target Jira staging table to its production counterpart
-- =============================================
CREATE PROCEDURE [dbo].[usp_Jira_Staging_Sync_Project_Category]
AS
BEGIN
    DELETE FROM	[dbo].[tbl_Jira_Project_Category]

	INSERT INTO [dbo].[tbl_Jira_Project_Category]
	(
	    [Project_Category_Id],
	    [Name],
	    [Description],
	    [Update_Refresh_Id]
	)
	SELECT [Project_Category_Id],
	    [Name],
	    [Description],
	    [Refresh_Id]
	FROM [dbo].[tbl_stg_Jira_Project_Category]
END
GO
