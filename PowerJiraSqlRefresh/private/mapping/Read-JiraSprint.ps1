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
            #have to take a weird approach to parsing due to the delimiter also being a valid character in the Goal value
            #OLD sample value: "id=865,rapidViewId=187,state=ACTIVE,name=GSIS Sprint 3,goal=Complete PowerBI Registration reporting, complete a POC for report embedding, develop the outline of the student profile and 1 tab, and begin addressing data service .Net core conversions,startDate=2019-09-04T18:54:32.477Z,endDate=2019-09-14T00:00:00.000Z,completeDate=<null>,sequence=865"
            #CURRENT sample value (2020-09-12): "@{id=992; name=Admin Unit Sprint 56,  Sept 5; state=closed; boardId=69; goal=; startDate=2020-08-24T20:46:04.947Z; endDate=2020-09-06T20:46:00.000Z; completeDate=2020-09-08T20:26:31.987Z}"
            $sections = $Data -split '='
            $resultObj = @{}
            $currProp = ''
            $sections | ForEach-Object {
                if ($_.ToString().StartsWith('@{')) {
                    $currProp = $_.ToString().Substring(2).Trim()
                } elseif ($_.ToString().EndsWith('}')) {
                    $resultObj.Add($currProp, $_.ToString().Substring(0, $_.ToString().Length - 1))
                }
                else {
                    $delimIndex = $_.ToString().LastIndexOf(';')
                    $resultObj.Add($currProp, $_.ToString().Substring(0, $delimIndex))
                    $currProp = $_.ToString().Substring($delimIndex + 1).Trim()
                }
            }
            #load the parsed array into a custom object
            [pscustomobject]@{
                Sprint_Id = [int]$resultObj.id
                Rapid_View_Id = [int]$resultObj.boardId
                State = $resultObj.state
                Name = $resultObj.name
                Goal = $resultObj.goal
                Start_Date = Format-SqlSafeSprintDate $resultObj.startDate
                End_Date = Format-SqlSafeSprintDate $resultObj.endDate
                Complete_Date = Format-SqlSafeSprintDate $resultObj.completeDate
                Sequence = 0
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