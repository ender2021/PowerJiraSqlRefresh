SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Justin Mead
-- Create date: 2019-09-19
-- Description:	Synchronize the target Jira staging table to its production counterpart
-- =============================================
CREATE PROCEDURE [dbo].[usp_Jira_Staging_Sync_Status_Category]
AS
BEGIN
    DELETE FROM	[dbo].[tbl_Jira_Status_Category]

	INSERT INTO [dbo].[tbl_Jira_Status_Category]
	(
	    [Status_Category_Id],
	    [Name],
	    [Key],
	    [Color_Name],
	    [Update_Refresh_Id]
	)
	SELECT [Status_Category_Id],
	    [Name],
	    [Key],
	    [Color_Name],
	    [Refresh_Id]
	FROM [dbo].[tbl_stg_Jira_Status_Category]
END
GO
