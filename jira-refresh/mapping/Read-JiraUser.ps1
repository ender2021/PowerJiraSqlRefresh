function Read-JiraUser {
    [CmdletBinding()]
    param (
        # User object
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
            Account_Id = [string]$Data.accountId
            Account_Type = $Data.accountType
            DisplayName = $Data.displayName
            Name = if($Data.name) {$Data.name} else {$null}
            Avatar_16 = $Data.avatarUrls.'16x16'
            Avatar_24 = $Data.avatarUrls.'24x24'
            Avatar_32 = $Data.avatarUrls.'32x32'
            Avatar_48 = $Data.avatarUrls.'48x48'
            Active = [boolean]$Data.active
            Refresh_Id = $RefreshId
        }
    }
    
    end {
    }
}