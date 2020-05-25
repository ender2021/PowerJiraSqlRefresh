SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dbo].[vw_Jira_User] AS
SELECT [Account_Id]
      ,[Account_Type]
      ,[DisplayName]
      ,[Name]
      ,[Avatar_16]
      ,[Avatar_24]
      ,[Avatar_32]
      ,[Avatar_48]
      ,[Active]
      ,[Update_Refresh_Id]
  FROM [dbo].[tbl_Jira_User]
GO
GRANT SELECT ON  [dbo].[vw_Jira_User] TO [JiraRefreshRole]
GO
