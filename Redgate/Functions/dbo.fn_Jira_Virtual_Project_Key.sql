SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Justin Mead
-- Create date: 2019-09-21
-- Description:	Calculates a virtual project key for an issue
-- =============================================
CREATE FUNCTION [dbo].[fn_Jira_Virtual_Project_Key]
(
	@Issue_Id AS INT
)
RETURNS VARCHAR(255)
AS
BEGIN
	DECLARE @id AS INT
	DECLARE @key AS VARCHAR(255)

	SELECT @key = CASE
					WHEN pv.[Project_Id] IS NULL THEN i.[Project_Key]
					ELSE pv.[Project_Key]
				  END
	FROM [Jira].[dbo].[vw_Jira_Issue_t1] AS i
	LEFT JOIN [dbo].[vw_Jira_Project_Virtual] pv
	ON pv.[Project_Key] = i.[Parent_Epic_Key]
	 OR pv.[Project_Key] = i.[Issue_Key]
	WHERE i.[Issue_Id] = @Issue_Id
	
	RETURN @key

END
GO
