function Write-AtlassianData {
    [CmdletBinding()]
    param (
        # The data to be written
        [Parameter(Mandatory, Position=0)]
        [AllowNull()]
        [object[]]
        $Data,

        # The connection string for the database server
        [Parameter(Mandatory, Position=1)]
        [string]
        $DatabaseServer,

        # The name of the database to write to
        [Parameter(Mandatory, Position=2)]
        [string]
        $DatabaseName,

        # The table's schema name
        [Parameter(Mandatory, Position=3)]
        [string]
        $SchemaName,

        # The name of the table to write to
        [Parameter(Mandatory, Position=4)]
        [string]
        $TableName,

        # Whether or not to force creation of the object
        [Parameter()]
        [switch]
        $Force
    )
    begin {
        $count = $Data.Count
        Write-Verbose "Writing $count record(s) to table $TableName"
    }
    
    process {
        if ($count -gt 0) {
            $take = 1000
            for($i=0; $i -lt $count; $i+=$take){

                $sqlParams = @{
                    InputData = $Data[$i..($i+$take-1)]
                    ServerInstance = $DatabaseServer
                    DatabaseName = $DatabaseName
                    SchemaName = $SchemaName
                    TableName = $TableName
                    Force = $Force
                    ConnectionTimeout = 60
                    Timeout = 60
                }
                Write-SqlTableData @sqlParams
            }
        }
    }
    end {
        
    }
}