SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Justin Mead
-- Create date: 2019-09-19
-- Description:	Synchronize the target Jira staging table to its production counterpart
-- =============================================
CREATE PROCEDURE [dbo].[usp_Jira_Staging_Sync_Issue_Type]
AS
BEGIN
    DELETE FROM	[dbo].[tbl_Jira_Issue_Type]
	WHERE [Issue_Type_Id] IN (SELECT DISTINCT [Issue_Type_Id] FROM [dbo].[tbl_stg_Jira_Issue_Type])

	INSERT INTO [dbo].[tbl_Jira_Issue_Type]
	(
	    [Issue_Type_Id],
	    [Name],
	    [Description],
	    [Icon_Url],
	    [Subtask_Type],
	    [Update_Refresh_Id]
	)
	SELECT [Issue_Type_Id],
		[Name],
		[Description],
		[Icon_Url],
		[Subtask_Type],
		[Refresh_Id]
	FROM [dbo].[tbl_stg_Jira_Issue_Type]
END
GO
