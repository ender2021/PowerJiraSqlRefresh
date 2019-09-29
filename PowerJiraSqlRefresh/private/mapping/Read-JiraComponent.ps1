function Read-JiraComponent {
    [CmdletBinding()]
    param (
        # Component object
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
            Component_Id = [int]$Data.id
            Project_Key = $Data.project
            Project_Id = [int]$Data.projectId
            Name = $Data.name
            Description = $Data.description
            Lead_User_Id = if ($Data.lead -and $Data.lead.accountId) {$Data.lead.accountId} else {$null}
            Lead_User_Name = if ($Data.lead -and $Data.lead.displayName) {$Data.lead.displayName} else {$null}
            Assignee_Type = $Data.assigneeType
            Real_Assignee_Type = $Data.realAssigneeType
            Assignee_Type_Valid = [boolean]$Data.isAssigneeTypeValid
            Refresh_Id = $RefreshId
        }
    }
    
    end {
    }
}