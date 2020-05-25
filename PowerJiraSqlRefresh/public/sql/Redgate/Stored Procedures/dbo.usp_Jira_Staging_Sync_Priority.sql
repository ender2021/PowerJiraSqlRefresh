SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Justin Mead
-- Create date: 2019-09-19
-- Description:	Synchronize the target Jira staging table to its production counterpart
-- =============================================
CREATE PROCEDURE [dbo].[usp_Jira_Staging_Sync_Priority]
AS
BEGIN
    DELETE FROM	[dbo].[tbl_Jira_Priority]

	INSERT INTO [dbo].[tbl_Jira_Priority]
	(
	    [Priority_Id],
	    [Name],
	    [Description],
	    [Icon_Url],
	    [Status_Color],
	    [Update_Refresh_Id]
	)
	SELECT [Priority_Id],
	    [Name],
	    [Description],
	    [Icon_Url],
	    [Status_Color],
	    [Refresh_Id]
	FROM [dbo].[tbl_stg_Jira_Priority]
END
GO
