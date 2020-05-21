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
        try {
            #extract the meaningful bit from the string
            $var = $Data -match '(?s)\[(.*)\]'
            $raw = $Matches[0]

            #have to take a weird approach to parsing due to the delimiter also being a valid character in the Goal value
            #sample value: "id=865,rapidViewId=187,state=ACTIVE,name=GSIS Sprint 3,goal=Complete PowerBI Registration reporting, complete a POC for report embedding, develop the outline of the student profile and 1 tab, and begin addressing data service .Net core conversions,startDate=2019-09-04T18:54:32.477Z,endDate=2019-09-14T00:00:00.000Z,completeDate=<null>,sequence=865"
            $sections = $raw -split '='
            $resultObj = @{}
            $currProp = ''
            $sections | ForEach-Object {
                if ($_.ToString().StartsWith('[')) {
                    $currProp = $_.ToString().Substring(1)
                } elseif ($_.ToString().EndsWith(']')) {
                    $resultObj.Add($currProp, $_.ToString().Substring(0, $_.ToString().Length - 1))
                }
                else {
                    $commaIndex = $_.ToString().LastIndexOf(',')
                    $resultObj.Add($currProp, $_.ToString().Substring(0, $commaIndex))
                    $currProp = $_.ToString().Substring($commaIndex + 1)
                }
            }
            #load the parsed array into a custom object
            [pscustomobject]@{
                Sprint_Id = [int]$resultObj.id
                Rapid_View_Id = [int]$resultObj.rapidViewId
                State = $resultObj.state
                Name = $resultObj.name
                Goal = $resultObj.goal
                Start_Date = if($resultObj.startDate -eq '<null>') { $null } else { [datetime](Get-Date $resultObj.startDate) }
                End_Date = if($resultObj.endDate -eq '<null>') { $null } else { [datetime](Get-Date $resultObj.endDate) }
                Complete_Date = if ($resultObj.completeDate -eq '<null>') { $null } else { [datetime](Get-Date $resultObj.completeDate) }
                Sequence = [int]$resultObj.sequence
                Refresh_Id = $RefreshId
            }
        }
        catch {
            Write-Error "Failed to parse sprint with data string: $Data"
            throw $_
        }
        
    }
    
    end {
    }
}