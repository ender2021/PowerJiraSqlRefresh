function Read-JiraProject {
    [CmdletBinding()]
    param (
        # Project object
        [Parameter(Mandatory,Position=0,ValueFromPipeline)]
        [pscustomobject]
        $Data,

        # Refresh ID
        [Parameter(Mandatory,Position=1)]
        [int]
        $RefreshId
    )
    
    begin {
    }
    
    process {
        [PSCustomObject]@{
            Project_Id = $Data.id
            Project_Key = $Data.key
            Project_Name = $Data.name
            Description = $Data.description
            Lead_User_Id = $Data.lead.accountId
            Lead_User_Name = $Data.lead.displayName
            Category_Id = $Data.projectCategory.id
            Project_Type_Key = $Data.projectTypeKey
            Simplified = [boolean]$Data.simplified
            Style = $Data.style
            Private = [boolean]$Data.isPrivate
            Refresh_Id = $RefreshId
        }
    }
    
    end {
    }
}