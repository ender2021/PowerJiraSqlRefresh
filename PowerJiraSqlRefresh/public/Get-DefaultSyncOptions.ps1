<#

.SYNOPSIS
	Get an object containing the default options for which Jira data elements will be synced

.DESCRIPTION
    Returns a hash with properties for each individually retrieved data object
    Each property contains either $true or $false to indicate whether it is synced by default
    Retrieve this object and modify the values, then supply it to Update-JiraSql to modify the default settings

#>
function Get-DefaultSyncOptions {
    [CmdletBinding()]
    param (
        
    )
    
    begin {
        
    }
    
    process {
        @{
            ProjectCategories = $true
            StatusCategories = $true
            Statuses = $true
            Resolutions = $true
            Priorities = $true
            IssueLinkTypes = $true
            Users = $true
            Projects = $true
            Worklogs = $true
            Issues = $true
            Deployments = $true
        }
    }
    
    end {
        
    }
}