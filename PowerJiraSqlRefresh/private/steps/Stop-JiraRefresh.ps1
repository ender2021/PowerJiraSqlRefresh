function Stop-JiraRefresh {
    [CmdletBinding()]
    param (
        # Id of the refresh batch to end
        [Parameter(Mandatory, Position=0)]
        [int]
        $RefreshId,

        # The sql instance to update data in
        [Parameter(Mandatory,Position=1)]
        [string]
        $SqlInstance,

        # The sql database to update data in
        [Parameter(Mandatory,Position=2)]
        [string]
        $SqlDatabase
    )
    
    begin {
        Write-Verbose "Recording Jira Refresh end (RefreshID: $RefreshId)"
    }
    
    process {
        Invoke-SqlCmd -ServerInstance $SqlInstance -Database $SqlDatabase -Query "EXEC dbo.usp_Jira_Refresh_Update_End $RefreshId"
    }
    
    end {
    }
}