SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author:		Justin Mead
-- Create date: 2019-09-28
-- Description:	Creates a new refresh record
-- =============================================
CREATE PROCEDURE [dbo].[usp_Jira_Refresh_Start]
	@Type AS CHAR(1)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @currDate AS DATETIME = GETDATE()
    
	INSERT INTO [dbo].[tbl_Jira_Refresh]
	(
	    [Refresh_Start],
	    [Refresh_Start_Unix],
		[Type],
		[Status]
	)
	VALUES
	(   @currDate,
	    DATEDIFF(s, '1970-01-01', @currDate),
		@Type,
		'S'
	    )

	SELECT @@IDENTITY AS [Refresh_Id]
END

GO
GRANT EXECUTE ON  [dbo].[usp_Jira_Refresh_Start] TO [JiraRefreshRole]
GO
