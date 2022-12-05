function Format-SqlSafeSprintDate {
    [CmdletBinding()]
    param (
        # Value from sprint date string
        [Parameter(Mandatory,Position=0,ValueFromPipeline)]
        [AllowEmptyString()]
        [string]
        $Date
    )
    
    begin {
        
    }
    
    process {
        if($null -eq $Date -or $Date -eq '<null>' -or $Date -eq '') { 
            $null 
        } else { 
            # Must be between 1/1/1753 12:00:00 AM and 12/31/9999 11:59:59 PM to be safe for SQL
            $formatDate = [datetime](Get-Date $Date) 
            if ($formatDate -lt (Get-Date '1/1/1753 12:00:00 AM') -or $formatDate -gt (Get-Date '12/31/9999 11:59:59 PM')) {
                $null
            } else {
                $formatDate
            }
        }
    }
    
    end {
        
    }
}
