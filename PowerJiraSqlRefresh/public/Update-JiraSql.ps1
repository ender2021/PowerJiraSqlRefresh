function Update-JiraSql {
    [CmdletBinding()]
    param (
        # Refresh type
        [Parameter(Mandatory, Position=0)]
        [string]
        $RefreshType,

        # Project keys
        [Parameter(Position=1)]
        [string[]]
        $ProjectKeys,

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
        Write-Verbose "Beginning Jira data update on $SqlInstance in database $SqlDatabase"
        ####################################################
        #  CONFIGURATION                                   #
        ####################################################

        #configure the database targets
        $sqlSplat = @{
            SqlInstance = $SqlInstance
            SqlDatabase = $SqlDatabase
        }

        ####################################################
        #  GET PREVIOUS BATCH INFO / CLEAR PREVIOUS BATCH  #
        ####################################################

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
        Update-JiraProjectCategories @refreshSplat
        Update-JiraStatusCategories @refreshSplat
        Update-JiraStatuses @refreshSplat
        Update-JiraResolutions @refreshSplat
        Update-JiraPriorities @refreshSplat
        Update-JiraIssueLinkTypes @refreshSplat
        Update-JiraUsers @refreshSplat

        ####################################################
        #  REFRESH STEP 2 - PROJECTS                       #
        ####################################################

        # update projects, and in the process get a full project key list if necessary
        $refreshProjectKeys = Update-JiraProjects -ProjectKeys $ProjectKeys @refreshSplat | ForEach-Object { $_.Project_Key }

        ####################################################
        #  REFRESH STEP 3 - PROJECT TAXONS                 #
        ####################################################

        # next do the updates where the only context is the list of projects
        $refreshProjectKeys | Update-JiraVersions @refreshSplat
        $refreshProjectKeys | Update-JiraComponents @refreshSplat

        ####################################################
        #  REFRESH STEP 4 - WORKLOGS                       #
        ####################################################

        # worklogs are refreshed based on the last unix timestamp of a refresh
        # need to both update changed / new worklogs, and remove any that have been deleted
        Update-JiraWorklogs -LastRefreshUnix $lastRefreshStamp @refreshSplat
        Remove-JiraWorklogs -LastRefreshUnix $lastRefreshStamp @sqlSplat

        ####################################################
        #  REFRESH STEP 5 - ISSUES                       #
        ####################################################

        # issues are retrieved using jql crafted from the date of last refresh and optionally a project key list

        # first format the date stamp and create the updated date clause
        $jqlUpdateDate = (Get-Date $lastRefreshDate -format "yyyy-MM-dd HH:mm")
        $updateJql = "updatedDate >= '$jqlUpdateDate'"

        # if we're refreshing a specific list of projects, create the clause; otherwise, don't add a project clause
        $projectJql = if($getAll) {
            ""
        } else {
            " AND Project in (" + ($refreshProjectKeys -join ",") + ")"
        }

        # update issues with the crafted JQL
        Update-JiraIssues -Jql ($updateJql + $projectJql) @refreshSplat

        #if we're doing a diff refresh, pull down ALL issue IDs for the listed projects, in order to detect deleted issues
        if ($RefreshType -eq (Get-JiraRefreshTypes).Differential) {
            # use the project list if we're doing a list, otherwise use a "true = true" type clause to get everything
            if ($null -eq $ProjectKeys) {
                Update-JiraDeletedIssues -Jql "project is not EMPTY" @sqlSplat
            } else {
                Update-JiraDeletedIssues -Jql $projectJql @sqlSplat
            }
        }

        ####################################################
        #  REFRESH STEP 6 - SYNC STAGING TO LIVE TABLES    #
        ####################################################

        Sync-JiraStaging -SyncDeleted ($RefreshType -eq $RefreshTypes.Differential) @sqlSplat
    }
    
    end {
        ####################################################
        #  RECORD BATCH END                                #
        ####################################################

        Stop-JiraRefresh @refreshSplat

        Write-Verbose "Jira update completed!"
    }
}