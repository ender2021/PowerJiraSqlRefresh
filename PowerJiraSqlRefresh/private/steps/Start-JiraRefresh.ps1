function Start-JiraRefresh {
    [CmdletBinding()]
    param (
        # Refresh type
        [Parameter(Mandatory,Position=0)]
        [string]
        $RefreshType,

        # The sql instance to update data in
        [Parameter(Mandatory,Position=1)]
        [string]
        $SqlInstance,

        # The sql database to update data in
        [Parameter(Mandatory,Position=2)]
        [string]
        $SqlDatabase,

        # The schema to use when updating data
        [Parameter(Position=3)]
        [string]
        $SchemaName="dbo"
    )
    
    begin {
    }
    
    process {
        #invoke the sproc to start a refresh and return the id it gives us
        (Invoke-SqlCmd -ServerInstance $SqlInstance -Database $SqlDatabase -Query "EXEC dbo.usp_Jira_Refresh_Start $RefreshType").Refresh_Id
    }
    
    end {
    }
}