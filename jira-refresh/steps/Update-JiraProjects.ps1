function Update-JiraProjects {
    [CmdletBinding()]
    param (
        # The list of project keys for projects to update
        [Parameter(Mandatory,Position=0,ValueFromPipeline)]
        [string[]]
        $ProjectKeys,

        # The ID value of the refresh underway
        [Parameter(Mandatory,Position=1)]
        [int]
        $RefreshId,

        # The sql instance to update data in
        [Parameter(Mandatory,Position=2)]
        [string]
        $SqlInstance,

        # The sql database to update data in
        [Parameter(Mandatory,Position=3)]
        [string]
        $SqlDatabase,

        # The schema to use when updating data
        [Parameter(Position=4)]
        [string]
        $SchemaName="dbo"
    )
    
    begin {
        Write-Verbose "Begin Jira Project Update"
        $tableName = "tbl_stg_Jira_Project"
        $projects = @()
    }
    
    process {
        Write-Verbose "Getting Jira Project for Project Key $_"
        $projects += Invoke-JiraGetProject $_ | Read-JiraProject -RefreshId $RefreshId
    }
    
    end {
        Write-Verbose "Writing Jira Projects to staging table"
        $projects | Write-SqlTableData -ServerInstance $SqlInstance -DatabaseName $SqlDatabase -SchemaName $SchemaName -TableName $tableName
        Write-Verbose "End Jira Project Update"
    }
}