function Get-LastJiraRefresh {
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
        Write-Verbose "Getting data for most recent refresh"
    }
    
    process {
        Invoke-SqlCmd -ServerInstance $SqlInstance -Database $SqlDatabase -Query "EXEC dbo.usp_Jira_Refresh_Get_Max"
    }
    
    end {
    }
}