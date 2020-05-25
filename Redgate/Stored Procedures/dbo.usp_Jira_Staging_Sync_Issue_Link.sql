SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Justin Mead
-- Create date: 2019-09-19
-- Description:	Synchronize the target Jira staging table to its production counterpart
-- =============================================
CREATE PROCEDURE [dbo].[usp_Jira_Staging_Sync_Issue_Link]
AS
BEGIN
    DELETE FROM [dbo].[tbl_Jira_Issue_Link]
	WHERE [In_Issue_Id] IN (SELECT [Issue_Id] FROM [dbo].[tbl_stg_Jira_Issue])
	   OR [Out_Issue_Id] IN (SELECT [Issue_Id] FROM [dbo].[tbl_stg_Jira_Issue])

	INSERT INTO [dbo].[tbl_Jira_Issue_Link]
	(
	    [Issue_Link_Id],
	    [Link_Type_Id],
	    [In_Issue_Id],
	    [In_Issue_Key],
	    [Out_Issue_Id],
	    [Out_Issue_Key],
	    [Update_Refresh_Id]
	)
	SELECT [Issue_Link_Id],
	    [Link_Type_Id],
	    [In_Issue_Id],
	    [In_Issue_Key],
	    [Out_Issue_Id],
	    [Out_Issue_Key],
	    [Refresh_Id]
	FROM [dbo].[tbl_stg_Jira_Issue_Link]
END
GO
