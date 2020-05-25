SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dbo].[vw_Jira_Project_Small]
AS
SELECT [epic].[Project_Id]
      ,[epic].[Issue_Key] AS [Project_Key]
	  ,[epic].[Epic_Name] AS [Project_Name]
	  ,[epic].[Description]
	  ,[epic].[Assignee_User_Id] AS [Lead_User_Id]
	  ,[epic].[Assignee_User_Name] AS [Lead_User_Name]
	  ,[proj].[Category_Id]
	  ,[proj].[Project_Type_Key]
	  ,[proj].[Simplified]
	  ,[proj].[Style]
	  ,[proj].[Private]
	  ,[epic].[Update_Refresh_Id]
FROM [dbo].[vw_Jira_Epic] AS epic
INNER JOIN [dbo].[tbl_Jira_Project] AS proj
ON [proj].[Project_Id] = [epic].[Project_Id]
INNER JOIN [dbo].[tbl_Jira_Project_Category] AS cat
ON proj.[Category_Id] = [cat].[Project_Category_Id]
WHERE cat.[Name] = 'Small Projects'
GO
GRANT SELECT ON  [dbo].[vw_Jira_Project_Small] TO [JiraRefreshRole]
GO
