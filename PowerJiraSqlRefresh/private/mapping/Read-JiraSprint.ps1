function Read-JiraSprint {
    [CmdletBinding()]
    param (
        # Sprint string
        [Parameter(Mandatory,Position=0,ValueFromPipeline)]
        [string]
        $Data,

        # Refresh ID
        [Parameter(Mandatory,Position=1)]
        [int]
        $RefreshId
    )
    
    begin {
    }
    
    process {
        #extract the meaningful bit from the string
        $var = $Data -match '(?s)\[(.*)\]'
        $raw = $Matches[0]

        #have to take a weird approach to parsing due to the delimiter also being a valid character in the Goal value
        #sample value: "id=865,rapidViewId=187,state=ACTIVE,name=GSIS Sprint 3,goal=Complete PowerBI Registration reporting, complete a POC for report embedding, develop the outline of the student profile and 1 tab, and begin addressing data service .Net core conversions,startDate=2019-09-04T18:54:32.477Z,endDate=2019-09-14T00:00:00.000Z,completeDate=<null>,sequence=865"
        $sections = $raw -split '='
        $strArr = @()
        $strArr += $sections | ForEach-Object {
            if ($_ -eq "[id") {
                return ''
            } elseif ($_.ToString().EndsWith(']')) { 
                return $_.ToString().Substring(0, $_.ToString().Length - 1)
            }
            else { return $_.ToString().Substring(0, $_.ToString().LastIndexOf(',')) }
        }
        #load the parsed array into a custom object
        [pscustomobject]@{
            Sprint_Id = [int]$strArr[1]
            Rapid_View_Id = [int]$strArr[2]
            State = $strArr[3]
            Name = $strArr[4]
            Goal = $strArr[5]
            Start_Date = if($strArr[6] -eq '<null>') { $null } else { [datetime](Get-Date $strArr[6]) }
            End_Date = if($strArr[7] -eq '<null>') { $null } else { [datetime](Get-Date $strArr[7]) }
            Complete_Date = if ($strArr[8] -eq '<null>') { $null } else { [datetime](Get-Date $strArr[8]) }
            Sequence = [int]$strArr[9]
            Refresh_Id = $RefreshId
        }
    }
    
    end {
    }
}