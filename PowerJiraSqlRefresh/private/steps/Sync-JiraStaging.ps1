function Sync-JiraStaging {
    [CmdletBinding()]
    param (
        # whether or not to run delete synchronization
        [Parameter(Mandatory,Position=0)]
        [bool]
        $SyncDeleted,

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
    }
    
    process {
        Invoke-SqlCmd -ServerInstance $SqlInstance -Database $SqlDatabase -Query "EXEC dbo.usp_Jira_Staging_Synchronize $SyncDeleted"
    }
    
    end {
    }
}