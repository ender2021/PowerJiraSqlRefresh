function Update-JiraComponents {
    [CmdletBinding()]
    param (
        # The list of project keys for which to retrieve components
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
        Write-Verbose "Updating Components"
        $tableName = "tbl_stg_Jira_Component"
        $components = @()
    }
    
    process {
        foreach($key in $ProjectKeys){
            Write-Verbose "Getting Components for Project Key $key"
            $components += Invoke-JiraGetProjectComponents $key | Read-JiraComponent -RefreshId $RefreshId
        }
    }
    
    end {
        Write-Verbose "Writing Components to staging table"
        $components | Write-SqlTableData -ServerInstance $SqlInstance -DatabaseName $SqlDatabase -SchemaName $SchemaName -TableName $tableName
    }
}