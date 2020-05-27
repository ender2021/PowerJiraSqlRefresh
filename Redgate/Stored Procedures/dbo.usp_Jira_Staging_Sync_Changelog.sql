SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- =============================================
-- Author:		Reuben Unruh
-- Create date: 2020-05-21
-- Description:	Synchronize the target Jira staging table to its production counterpart
-- =============================================
CREATE PROCEDURE [dbo].[usp_Jira_Staging_Sync_Changelog]
AS
BEGIN
    DELETE FROM	[dbo].[tbl_Jira_Changelog]
	WHERE [Changelog_Id] IN (SELECT DISTINCT [Changelog_Id] FROM [dbo].[tbl_stg_Jira_Changelog])

	INSERT INTO [dbo].[tbl_Jira_Changelog]
	(
	    [Changelog_Id],
		[Author_User_Id],
		[Created_Date],
		[Changelog_Items],
		[Issue_Id],
	    [Update_Refresh_Id]
	)
	SELECT [Changelog_Id],
		[Author_User_Id],
		[Created_Date],
		[Changelog_Items],
		[Issue_Id],
		[Refresh_Id]
	FROM [dbo].[tbl_stg_Jira_Changelog]
END


GO
GRANT EXECUTE ON  [dbo].[usp_Jira_Staging_Sync_Changelog] TO [JiraRefreshRole]
GO
