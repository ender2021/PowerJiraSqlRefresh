function Update-JiraProjects {
    [CmdletBinding()]
    param (
        # The list of project keys for projects to update
        [Parameter(Mandatory,Position=0,ValueFromPipeline)]
        [AllowEmptyCollection()]
        [AllowNull()]
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
        Write-Verbose "Updating Projects"
        $tableName = "tbl_stg_Jira_Project"
        $projects = @()
        
        #if no keys were supplied, then get all projects
        if (($null -eq $ProjectKeys) -or ($ProjectKeys.Count -eq 0))
        {
            Write-Verbose "Getting all Projects"
            $startAt = 0
            $lastPageReached = $false
            do {
                Write-Verbose "Getting Project results $startAt to " + [string]($startAt + 50)
                #get a set of results
                $result = Invoke-JiraGetProjects -MaxResults 50 -StartAt $startAt -Expand @("description","lead")
    
                #process the results, if there were more than zero
                if ($result.values.Count -ne 0) {
                    #transform the projects into objects and keep them, if we don't have them already
                    $projects += $result.values | Where-Object {
                        ($projects | ForEach-Object {$_.Project_Key}) -notcontains $_.key
                    } | Read-JiraProject -RefreshId $RefreshId
                }
    
                #set the startAt for the potential next call
                $startAt += $result.values.Count
    
                #check if we've reached the last page
                if ($result.isLast) {
                    $lastPageReached = $true
                }
    
                #keep going unless we've reached the end of the results
            } while (!$lastPageReached)
        }
    }
    
    process {
        #if keys were supplied, then we loop through them and get projects
        if ($_) {
            Write-Verbose "Getting Project for Key $_"
            $projects += Invoke-JiraGetProject $_ | Read-JiraProject -RefreshId $RefreshId
        }
    }
    
    end {
        Write-Verbose "Writing Projects to staging table"
        $projects | Write-SqlTableData -ServerInstance $SqlInstance -DatabaseName $SqlDatabase -SchemaName $SchemaName -TableName $tableName
        # this function is unique - need to return the objects in order to make sure the project key list for future requests is accurate
        $projects
    }
}