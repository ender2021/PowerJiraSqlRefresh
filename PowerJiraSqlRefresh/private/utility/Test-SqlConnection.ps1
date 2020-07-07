#modified from: https://stackoverflow.com/questions/29229109/test-database-connectivity
function Test-SqlConnection
{    
    [OutputType([bool])]
    Param
    (
        # The server to connect to
        [Parameter(Mandatory, Position=0)]
        [string]
        $SqlInstance,

        # The database to connect to
        [Parameter(Mandatory, Position=1)]
        [string]
        $SqlDatabase
    )
    process {
        try
        {
            Write-Verbose ("Testing connection to database $SqlDatabase on server $SqlInstance with user " + $env:UserName)
            $sqlConnection = New-Object System.Data.SqlClient.SqlConnection "Server=$SqlInstance;Database=$SqlDatabase;Trusted_Connection=True;"
            $sqlConnection.Open();
            $sqlConnection.Close();
    
            Write-Verbose "Connection test succeeded"
            return $true;
        }
        catch
        {
            Write-Verbose "Connection test failed"
            return $false;
        }
    }
}