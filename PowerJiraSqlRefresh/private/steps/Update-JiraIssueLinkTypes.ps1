function Update-JiraIssueLinkTypes {
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
        Write-Verbose "Begin Jira Issue Link Type Update"
        $tableName = "tbl_stg_Jira_Issue_Link_Type"
        $types = @()
    }
    
    process {
        Write-Verbose "Getting Jira Issue Link Type"
        $types += (Invoke-JiraGetIssueLinkTypes) | Read-JiraIssueLinkType -RefreshId $RefreshId
    }
    
    end {
        Write-Verbose "Writing Jira Issue Link Type to staging table"
        $types | Write-SqlTableData -ServerInstance $SqlInstance -DatabaseName $SqlDatabase -SchemaName $SchemaName -TableName $tableName
        Write-Verbose "End Jira Issue Link Type Update"
    }
}