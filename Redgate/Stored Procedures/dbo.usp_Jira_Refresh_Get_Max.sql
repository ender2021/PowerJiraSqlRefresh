SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Justin Mead
-- Create date: 2019-09-12
-- Description:	Get the most recent jira refresh record
-- =============================================
CREATE PROCEDURE [dbo].[usp_Jira_Refresh_Get_Max]
	AS
BEGIN
	SET NOCOUNT ON;

	SELECT TOP 1
		   [Refresh_ID]
		  ,[Refresh_Start]
		  ,[Refresh_Start_Unix]
	FROM [dbo].[tbl_Jira_Refresh]
	WHERE [Deleted] = 0
	ORDER BY [Refresh_Start] DESC
END
GO
GRANT EXECUTE ON  [dbo].[usp_Jira_Refresh_Get_Max] TO [JiraRefreshRole]
GO
