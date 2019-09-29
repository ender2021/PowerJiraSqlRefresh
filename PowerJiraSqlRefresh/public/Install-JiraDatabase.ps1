function Install-JiraDatabase {
    [CmdletBinding()]
    param (
        # The sql instance of the install database
        [Parameter(Mandatory,Position=0)]
        [string]
        $SqlInstance,

        # The name of the install sql database
        [Parameter(Mandatory,Position=1)]
        [string]
        $SqlDatabase
    )
    
    begin {
        Write-Verbose "Installing Jira database on $SqlInstance in database $SqlDatabase"
    }
    
    process {
        Write-Verbose "Creating database objects"
        $objectsResult = Invoke-SqlCmd -ServerInstance $SqlInstance -Database $SqlDatabase -InputFile $global:PowerJiraSqlRefresh.SqlObjectsPath

        Write-Verbose "Creating lookup table data"
        $lookupResult = Invoke-SqlCmd -ServerInstance $SqlInstance -Database $SqlDatabase -InputFile $global:PowerJiraSqlRefresh.SqlLookupsPath
    }
    
    end {
        Write-Verbose "Jira database installation completed"
    }
}