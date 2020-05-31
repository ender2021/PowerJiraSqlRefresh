SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author:		Justin Mead
-- Create date: 2020-05-30
-- Description:	Synchronize the target Jira staging table to its production counterpart
-- =============================================
CREATE PROCEDURE [dbo].[usp_Jira_Staging_Sync_Project_Role]
AS
BEGIN
    DELETE FROM	[dbo].[tbl_Jira_Project_Role]

	INSERT INTO [dbo].[tbl_Jira_Project_Role]
	(
	    [Role_Id],
	    [Name],
	    [Refresh_Id]
	)
	SELECT [Role_Id],
           [Name],
           [Refresh_Id]
	FROM [dbo].[tbl_stg_Jira_Project_Role]
END
GO
