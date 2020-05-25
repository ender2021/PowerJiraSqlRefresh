SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Justin Mead
-- Create date: 2019-09-19
-- Description:	Synchronize the target Jira staging table to its production counterpart
-- =============================================
CREATE PROCEDURE [dbo].[usp_Jira_Staging_Sync_Status]
AS
BEGIN
    DELETE FROM	[dbo].[tbl_Jira_Status]

	INSERT INTO [dbo].[tbl_Jira_Status]
	(
	    [Status_Id],
	    [Status_Catgory_Id],
	    [Name],
	    [Description],
	    [Icon_Url],
	    [Update_Refresh_Id]
	)
	SELECT [Status_Id],
	    [Status_Catgory_Id],
	    [Name],
	    [Description],
	    [Icon_Url],
	    [Refresh_Id]
	FROM [dbo].[tbl_stg_Jira_Status]
END
GO
