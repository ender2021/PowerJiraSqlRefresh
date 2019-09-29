function Update-JiraStatuses {
    [CmdletBinding()]
    param (
        # The ID value of the refresh underway
        [Parameter(Mandatory,Position=0)]
        [int]
        $RefreshId,

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
        Write-Verbose "Updating Statuses"
        $tableName = "tbl_stg_Jira_Status"
        $statuses = @()
    }
    
    process {
        Write-Verbose "Getting Statuses"
        $statuses += (Invoke-JiraGetAllStatuses) | Read-JiraStatus -RefreshId $RefreshId
    }
    
    end {
        Write-Verbose "Writing Statuses to staging table"
        $statuses | Write-SqlTableData -ServerInstance $SqlInstance -DatabaseName $SqlDatabase -SchemaName $SchemaName -TableName $tableName
    }
}