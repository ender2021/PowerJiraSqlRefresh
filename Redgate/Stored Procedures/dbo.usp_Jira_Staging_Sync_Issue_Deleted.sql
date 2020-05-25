SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Justin Mead
-- Create date: 2019-09-19
-- Description:	Synchronize the target Jira staging table to its production counterpart
-- =============================================
CREATE PROCEDURE [dbo].[usp_Jira_Staging_Sync_Issue_Deleted]
AS
BEGIN
    DELETE iss
	FROM [dbo].[tbl_stg_Jira_Issue_All_Id] AS id
	RIGHT JOIN [dbo].[tbl_Jira_Issue] AS iss
	ON [iss].[Issue_Id] = [id].[Issue_Id]
	WHERE id.[Issue_Id] IS null
END
GO
