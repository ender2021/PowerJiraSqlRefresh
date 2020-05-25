SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Justin Mead
-- Create date: 2019
-- Description:	Gets the Epic name or summary for the related epic of an issue, if any
-- =============================================
CREATE FUNCTION [dbo].[fn_Jira_Epic]
(
	@Issue_Id INT,
	@Default AS VARCHAR(200)='Uncategorized'
)
RETURNS VARCHAR(200)
AS
BEGIN
	
	DECLARE @Epic AS VARCHAR(200)

	SELECT TOP 1 @Epic = ISNULL([E].[Epic_Name], [e].[Summary])
	FROM [dbo].[vw_Jira_Epic] AS [E]
	INNER JOIN [dbo].[tbl_Jira_Issue] AS [I]
	ON [I].[Epic_Key] = [E].[Issue_Key]
	WHERE [I].[Issue_Id] = @Issue_Id

	RETURN ISNULL(@Epic, @Default)

END
GO
