SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Justin Mead
-- Create date: 2019-09-19
-- Description:	Synchronize the target Jira staging table to its production counterpart
-- =============================================
CREATE PROCEDURE [dbo].[usp_Jira_Staging_Sync_Issue_Sprint]
AS
BEGIN
    DELETE FROM [dbo].[tbl_Jira_Issue_Sprint]
	WHERE [Issue_Id] IN (SELECT DISTINCT [Issue_Id] FROM [dbo].[tbl_stg_Jira_Issue])

	INSERT INTO [dbo].[tbl_Jira_Issue_Sprint]
	(
	    [Sprint_Id],
	    [Issue_Id],
	    [Update_Refresh_Id]
	)
	SELECT DISTINCT [Sprint_Id],
	    [Issue_Id],
	    [Refresh_Id]
	FROM [dbo].[tbl_stg_Jira_Issue_Sprint]
END
GO
