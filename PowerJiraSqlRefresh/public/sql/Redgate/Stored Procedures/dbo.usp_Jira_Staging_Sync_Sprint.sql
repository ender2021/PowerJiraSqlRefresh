SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Justin Mead
-- Create date: 2019-09-19
-- Description:	Synchronize the target Jira staging table to its production counterpart
-- =============================================
CREATE PROCEDURE [dbo].[usp_Jira_Staging_Sync_Sprint]
AS
BEGIN
    DELETE FROM [dbo].[tbl_Jira_Sprint]
	WHERE [Sprint_Id] IN (SELECT DISTINCT [Sprint_Id] FROM [dbo].[tbl_stg_Jira_Sprint])

	INSERT INTO [dbo].[tbl_Jira_Sprint]
	(
	    [Sprint_Id],
	    [Rapid_View_Id],
	    [State],
	    [Name],
	    [Goal],
	    [Start_Date],
	    [End_Date],
	    [Complete_Date],
	    [Sequence],
	    [Update_Refresh_Id]
	)
	SELECT [Sprint_Id],
	    [Rapid_View_Id],
	    [State],
	    [Name],
	    [Goal],
	    [Start_Date],
	    [End_Date],
	    [Complete_Date],
	    [Sequence],
	    [Refresh_Id]
	FROM [dbo].[tbl_stg_Jira_Sprint]
END
GO
