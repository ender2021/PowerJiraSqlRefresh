function Read-JiraVersion {
    [CmdletBinding()]
    param (
        # Version object
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
            Version_Id = [int]$Data.id
            Project_Id = [int]$Data.projectId
            Name = $Data.name
            Archived = [boolean]$Data.archived
            Released = [boolean]$Data.released
            Start_Date = if ($Data.startDate) {[datetime]$Data.startDate} else {$null}
            Release_Date = if ($Data.releaseDate) {[datetime]$Data.releaseDate} else {$null}
            User_Start_Date = if ($Data.userStartDate) {[datetime]$Data.userStartDate} else {$null}
            User_Release_Date = if ($Data.userReleaseDate) {[datetime]$Data.userReleaseDate} else {$null}
            Refresh_Id = $RefreshId
        }
    }
    
    end {
    }
}