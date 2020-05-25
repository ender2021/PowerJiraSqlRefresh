SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Justin Mead
-- Create date: 2019-09-16
-- Description:	Get the Parent Epic for a given issue ID
-- =============================================
CREATE FUNCTION [dbo].[fn_Jira_Parent_Epic]
(
	@Issue_Id AS INT
)
RETURNS VARCHAR(500)
AS
BEGIN
	DECLARE @parentEpic AS VARCHAR(500)

	SELECT @parentEpic = CASE
							WHEN [IT].[Subtask_Type] = 1 THEN (SELECT [P].[Epic_Key] FROM [dbo].[tbl_Jira_Issue] AS [P] WHERE [P].[Issue_Id] = [I].[Parent_Id])
							ELSE [I].[Epic_Key]
						 END
	FROM [dbo].[tbl_Jira_Issue] AS [I]
	INNER JOIN [dbo].[tbl_Jira_Issue_Type] AS IT
	ON [IT].[Issue_Type_Id] = [I].[Issue_Type_Id]
	WHERE i.[Issue_Id] = @Issue_Id

	RETURN @parentEpic
END
GO
