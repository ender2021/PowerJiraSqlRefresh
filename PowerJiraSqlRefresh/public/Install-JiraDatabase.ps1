<#

.SYNOPSIS
	Install the Jira database objects used by the PowerJiraSqlRefresh module

.DESCRIPTION
    Runs SQL scripts embedded in the PowerJiraSqlRefresh module to create objects and data
    First creates all schema objects, then populates lookup tables with data

.PARAMETER SqlInstance
	The connection string for the SQL instance to install the Jira database on

.PARAMETER SqlDatabase
	The name of the database to install the Jira objects and data in

.EXAMPLE
	Install-JiraDatabase -SqlInstance localhost -SqlDatabase Jira

	Installs objects and data on the local machine in a database called "Jira"

.EXAMPLE
	Install-JiraDatabase -SqlInstance "my.remote.sql.server,1234" -SqlDatabase Jira

	Installs objects and data on a remote Sql Server in a database called "Jira"
#>
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