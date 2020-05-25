SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Justin Mead
-- Create date: 2019-09-19
-- Description:	Synchronize the target Jira staging table to its production counterpart
-- =============================================
CREATE PROCEDURE [dbo].[usp_Jira_Staging_Sync_Link_Type]
AS
BEGIN
    DELETE FROM [dbo].[tbl_Jira_Issue_Link_Type]

	INSERT INTO [dbo].[tbl_Jira_Issue_Link_Type]
	(
	    [Issue_Link_Type_Id],
	    [Name],
	    [Inward_Label],
	    [Outward_Label],
	    [Update_Refresh_Id]
	)
	SELECT [Issue_Link_Type_Id],
	    [Name],
	    [Inward_Label],
	    [Outward_Label],
	    [Refresh_Id]
	FROM [dbo].[tbl_stg_Jira_Issue_Link_Type]
END
GO
