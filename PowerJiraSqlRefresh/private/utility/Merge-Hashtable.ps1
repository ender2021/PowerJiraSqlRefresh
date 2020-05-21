#Adapted from the accepted answer here: https://stackoverflow.com/questions/8800375/merging-hashtables-in-powershell-how
function Merge-Hashtable {
    [CmdletBinding()]
    param (
        # The hashtable to be overwritten
        [Parameter(Mandatory,Position=0)]
        [hashtable]
        $Target,

        # The hashtable to overwrite with
        [Parameter(Mandatory,Position=1)]
        [hashtable]
        $Source
    )
    
    begin {
        
    }
    
    process {
        $keys = $Target.getenumerator() | foreach-object {$_.key}
        $keys | foreach-object {
            $key = $_
            if ($Source.containskey($key))
            {
                $Target.remove($key)
            }
        }
        $Source = $Target + $Source
        return $Source
    }
    
    end {
        
    }
}