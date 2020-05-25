SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Justin Mead
-- Create date: 2019
-- Description:	Gets the alphabetically first component related to an issue
-- =============================================
CREATE FUNCTION [dbo].[fn_Jira_First_Component]
(
	@Issue_Id INT,
	@Default AS VARCHAR(200)='Uncategorized'
)
RETURNS VARCHAR(200)
AS
BEGIN
	
	DECLARE @Component AS VARCHAR(200)

	SELECT TOP 1 @Component = [C].[Name]
	FROM [dbo].[tbl_Jira_Component] AS [C]
	INNER JOIN [dbo].[tbl_Jira_Issue_Component] AS [IC]
	ON [IC].[Component_Id] = [C].[Component_Id]
	INNER JOIN [dbo].[tbl_Jira_Issue] AS [I]
	ON [I].[Issue_Id] = [IC].[Issue_Id]
	WHERE [I].[Issue_Id] = @Issue_Id
	ORDER BY [c].[Name] ASC

	RETURN ISNULL(@Component, @Default)

END
GO
