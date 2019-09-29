function Clear-JiraRefresh {
    [CmdletBinding()]
    param (
        # The sql instance to update data in
        [Parameter(Mandatory,Position=0)]
        [string]
        $SqlInstance,

        # The sql database to update data in
        [Parameter(Mandatory,Position=1)]
        [string]
        $SqlDatabase
    )
    
    begin {
        Write-Verbose "Clearing all refresh data from Jira database"
    }
    
    process {
        Invoke-SqlCmd -ServerInstance $SqlInstance -Database $SqlDatabase -Query "EXEC dbo.usp_Jira_Refresh_Clear_All"
    }
    
    end {
    }
}