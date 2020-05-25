SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Justin Mead
-- Create date: 2019-09-19
-- Description:	Synchronize the target Jira staging table to its production counterpart
-- =============================================
CREATE PROCEDURE [dbo].[usp_Jira_Staging_Sync_User]
AS
BEGIN
    DELETE FROM [dbo].[tbl_Jira_User]

	INSERT INTO [dbo].[tbl_Jira_User]
	(
	    [Account_Id],
	    [Account_Type],
	    [DisplayName],
	    [Name],
	    [Avatar_16],
	    [Avatar_24],
	    [Avatar_32],
	    [Avatar_48],
	    [Active],
	    [Update_Refresh_Id]
	)
	SELECT [Account_Id],
	    [Account_Type],
	    [DisplayName],
	    [Name],
	    [Avatar_16],
	    [Avatar_24],
	    [Avatar_32],
	    [Avatar_48],
	    [Active],
	    [Refresh_Id]
	FROM [dbo].[tbl_stg_Jira_User]
END
GO
