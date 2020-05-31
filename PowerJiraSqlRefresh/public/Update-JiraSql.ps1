<#

.SYNOPSIS
	Update a Jira SQL database with data from a Jira Cloud instance

.DESCRIPTION
    Executes the necessary steps to update a SQL datastore of Jira data from a Jira Cloud instance
    A PowerJira Session must be opened with Open-JiraSession before calling this method

.PARAMETER RefreshType
    Indicates whether to do a Full or Differential refresh.  Use values from Get-JiraRefreshTypes

.PARAMETER ProjectKeys
    Supply this parameter in order to limit the refresh to a specified set of projects.
    Without this parameter, the method will update all projects

.PARAMETER Obfuscate
    Supply this parameter to obfuscate issue information in sensitive projects
    Issue Summary and Description will be replaced the with the string [Obfuscated]

.PARAMETER SqlInstance
	The connection string for the SQL instance where the data will be updated

.PARAMETER SqlDatabase
    The name of the database to perform updates in
    
.PARAMETER SyncDeployments
    Use this switch to sync deployment information from third-party providers.
    https://developer.atlassian.com/cloud/jira/software/modules/deployment/
    
.EXAMPLE
    Open-JiraSession @jiraConnectionDetails
	Update-Jira -RefreshType (Get-JiraRefreshTypes).Full -SqlInstance localhost -SqlDatabase Jira
    Close-JiraSession

	Performs a full refresh of all Jira projects on a local sql database

.EXAMPLE
    Open-JiraSession @jiraConnectionDetails
    $Params = @{
        RefreshType = (Get-JiraRefreshTypes).Differential
        ProjectKeys = @("PROJKEY","MJPK","KEY3")
        SqlInstance = "my.remote.sql.server,1234"
        SqlDatabase = "Jira"
    }
	Update-Jira @Params
    Close-JiraSession

	Performs a differential refresh of 3 Jira projects on a remote Sql Server

#>
function Update-JiraSql {
    [CmdletBinding()]
    param (
        # Refresh type
        [Parameter(Mandatory, Position=0)]
        [ValidateSet("F","D")]
        [string]
        $RefreshType,

        # Keys of specific projects to pull
        [Parameter(Position=1)]
        [string[]]
        $ProjectKeys,

        # Keys of projects to be obfuscated
        [Parameter(Position=2)]
        [string[]]
        $Obfuscate,

        # The sql instance to update data in
        [Parameter(Mandatory,Position=3)]
        [string]
        $SqlInstance,

        # The sql database to update data in
        [Parameter(Mandatory,Position=4)]
        [string]
        $SqlDatabase,

        # Synchronization options to override the defaults
        [Parameter()]
        [hashtable]
        $SyncOptions
    )
    
    begin {
        Write-Verbose "Beginning Jira data update on $SqlInstance in database $SqlDatabase"
        ####################################################
        #  CONFIGURATION                                   #
        ####################################################

        #configure the database targets
        $sqlSplat = @{
            SqlInstance = $SqlInstance
            SqlDatabase = $SqlDatabase
        }

        #setup the sync options
        $options = Get-DefaultJiraSyncOptions
        if ($SyncOptions) {
            $options = Merge-Hashtable -Source $SyncOptions -Target $options
        }

        ####################################################
        #  GET PREVIOUS BATCH INFO / CLEAR PREVIOUS BATCH  #
        ####################################################

        $RefreshTypes = Get-JiraRefreshTypes

        if ($RefreshType -eq $RefreshTypes.Full) {
            Clear-JiraRefresh @sqlSplat
            $lastRefreshStamp = 0
            $lastRefreshDate = (Get-Date '1970-01-01')
        } else {
            $lastRefresh = Get-LastJiraRefresh @sqlSplat
            $lastRefreshStamp = $lastRefresh.Refresh_Start_Unix
            $lastRefreshDate = $lastRefresh.Refresh_Start
        }

        ####################################################
        #  BEGIN THE REFRESH BATCH                         #
        ####################################################

        Clear-JiraStaging @sqlSplat
        $refreshId = Start-JiraRefresh -RefreshType $RefreshType @sqlSplat
    }
    
    process {
        ####################################################
        #  REFRESH STEP 0 - CONFIGURE                      #
        ####################################################

        # define a convenient hash for splatting the basic refresh arguments
        $refreshSplat = @{
            RefreshId = $refreshId
        } + $sqlSplat

        ####################################################
        #  REFRESH STEP 1 - NO CONTEXT DATA                #
        ####################################################

        # these are mostly lookup tables
        if ($options.ProjectCategories) { Update-JiraProjectCategories @refreshSplat } else { Write-Verbose "Skipping Project Categories" }
        if ($options.StatusCategories) { Update-JiraStatusCategories @refreshSplat } else { Write-Verbose "Skipping Status Categories" }
        if ($options.Statuses) { Update-JiraStatuses @refreshSplat } else { Write-Verbose "Skipping Statuses" }
        if ($options.Resolutions) { Update-JiraResolutions @refreshSplat } else { Write-Verbose "Skipping Resolutions" }
        if ($options.Priorities) { Update-JiraPriorities @refreshSplat } else { Write-Verbose "Skipping Priorities" }
        if ($options.IssueLinkTypes) { Update-JiraIssueLinkTypes @refreshSplat } else { Write-Verbose "Skipping Issue Link Types" }
        if ($options.Users) { Update-JiraUsers @refreshSplat } else { Write-Verbose "Skipping Users" }

        ####################################################
        #  REFRESH STEP 2 - PROJECTS                       #
        ####################################################

        if ($options.ContainsKey("Projects") -and $options.Projects -ne $false) {
            # update projects, and in the process get a full project key list if necessary
            $refreshProjectKeys = Update-JiraProjects -ProjectKeys $ProjectKeys @refreshSplat | ForEach-Object { $_.Project_Key }
        } else {
            $refreshProjectKeys = $ProjectKeys
            Write-Verbose "Skipping Projects"
        }

        ####################################################
        #  REFRESH STEP 3 - PROJECT DETAILS                #
        ####################################################

        if ($options.ContainsKey("Projects") -and $options.Projects.GetType().Name -eq "Hashtable") {
            # next do the updates where the only context is the list of projects
            if ($options.Projects.ContainsKey("Versions") -and $options.Projects.Versions -ne $false) { Update-JiraVersions -ProjectKeys $refreshProjectKeys @refreshSplat } else { Write-Verbose "Skipping Project Versions" }
            if ($options.Projects.ContainsKey("Components") -and $options.Projects.Components -ne $false) { Update-JiraComponents -ProjectKeys $refreshProjectKeys @refreshSplat } else { Write-Verbose "Skipping Project Components" }
            if ($options.Projects.ContainsKey("Actors") -and $options.Projects.Actors -ne $false) { Update-JiraProjectActors -ProjectKeys $refreshProjectKeys @refreshSplat } else { Write-Verbose "Skipping Project Actors" }
        } else {
            Write-Verbose "Skipping Project Details"
        }

        ####################################################
        #  REFRESH STEP 4 - WORKLOGS                       #
        ####################################################

        if ($options.Worklogs) {
            # worklogs are refreshed based on the last unix timestamp of a refresh
            # need to both update changed / new worklogs, and remove any that have been deleted
            Update-JiraWorklogs -LastRefreshUnix $lastRefreshStamp @refreshSplat
            Remove-JiraWorklogs -LastRefreshUnix $lastRefreshStamp @sqlSplat
        } else {
            Write-Verbose "Skipping Worklogs"
        }
        

        ####################################################
        #  REFRESH STEP 5 - ISSUES                       #
        ####################################################

        if ($options.ContainsKey("Issues") -and $options.Issues -ne $false) {
            # issues are retrieved using jql crafted from the date of last refresh and optionally a project key list

            # first format the date stamp and create the updated date clause
            $jqlUpdateDate = (Get-Date $lastRefreshDate -format "yyyy-MM-dd HH:mm")
            $updateJql = "updatedDate >= '$jqlUpdateDate'"

            # if we're refreshing a specific list of projects, create the clause; otherwise, don't add a project clause
            $projectJql = if($null -eq $ProjectKeys -or $ProjectKeys.Count -eq 0) {
                ""
            } else {
                " AND Project in (" + ($refreshProjectKeys -join ",") + ")"
            }

            # update issues with the crafted JQL
            $updateIssueParams = @{
                Jql = $updateJql + $projectJql
                Obfuscate = $Obfuscate
            }
            if ($options.Issues.GetType().Name -eq "Hashtable") { $updateIssueParams.Add("SyncOptions",$options.Issues) }
            $updateIssueParams += $refreshSplat
            Update-JiraIssues @updateIssueParams

            #if we're doing a diff refresh, pull down ALL issue IDs for the listed projects, in order to detect deleted issues
            $deleteRetrieveSuccess = $false
            if ($RefreshType -eq (Get-JiraRefreshTypes).Differential) {
                # use the project list if we're doing a list, otherwise use a "true = true" type clause to get everything
                $deleteRetrieveSuccess = if ($null -eq $ProjectKeys) {
                    Update-JiraDeletedIssues -Jql "project is not EMPTY" @sqlSplat
                } else {
                    Update-JiraDeletedIssues -Jql $projectJql @sqlSplat
                }
            }
        } else {
            Write-Verbose "Skipping Issues"
        }
        

        ####################################################
        #  REFRESH STEP 6 - SYNC STAGING TO LIVE TABLES    #
        ####################################################

        #determine if deletes should be synced
        $syncDelete = $deleteRetrieveSuccess -and ($RefreshType -eq $RefreshTypes.Differential)

        #perform the sync
        Sync-JiraStaging -SyncDeleted $syncDelete @sqlSplat
    }
    
    end {
        ####################################################
        #  RECORD BATCH END                                #
        ####################################################

        Stop-JiraRefresh @refreshSplat

        Write-Verbose "Jira update completed!"
    }
}