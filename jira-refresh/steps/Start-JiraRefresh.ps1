function Start-JiraRefresh {
    [CmdletBinding()]
    param (
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
    }
    
    process {
        #create a new refresh batch object and write it to the database
        @(
            [PSCustomObject]@{
                Refresh_Id = ''
                Refresh_Start = [datetime](Get-Date)
                Refresh_Start_Unix = [int][double]::Parse((Get-Date -UFormat %s))
            }
        ) | Write-SqlTableData -ServerInstance $SqlInstance -DatabaseName $SqlDatabase -SchemaName $SchemaName -TableName "tbl_Jira_Refresh"

        #return the id of the batch we just started
        (Invoke-SqlCmd -ServerInstance $SqlInstance -Database $SqlDatabase -Query "EXEC dbo.usp_Jira_Refresh_Get_Max").Refresh_Id
    }
    
    end {
    }
}