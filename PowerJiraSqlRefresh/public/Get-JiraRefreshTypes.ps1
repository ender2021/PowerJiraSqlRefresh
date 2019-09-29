<#
.SYNPOSIS
	Get an object containing the values of Jira Refresh Types

.DESCRIPTION
    Returns a hash with properties Full and Differential
    Each property contains the code value of the Refresh Type it represents

#>
function Get-JiraRefreshTypes {
    [CmdletBinding()]
    param (
        
    )
    
    begin {
        
    }
    
    process {
        @{
            Full = "F"
            Differential = "D"
        }
    }
    
    end {
        
    }
}