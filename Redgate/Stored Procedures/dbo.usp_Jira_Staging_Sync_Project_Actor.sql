SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author:		Justin Mead
-- Create date: 2020-05-30
-- Description:	Synchronize the target Jira staging table to its production counterpart
-- =============================================
CREATE PROCEDURE [dbo].[usp_Jira_Staging_Sync_Project_Actor]
AS
BEGIN
    DELETE FROM	[dbo].[tbl_Jira_Project_Actor]

	INSERT	INTO [dbo].[tbl_Jira_Project_Actor]
	(
	    [Actor_Id],
	    [Project_Key],
	    [Role_Id],
	    [Type],
	    [Actor],
	    [Refresh_Id]
	)
	SELECT [Actor_Id],
           [Project_Key],
           [Role_Id],
           [Type],
           [Actor],
           [Refresh_Id]
	FROM [dbo].[tbl_stg_Jira_Project_Actor]
END
GO
