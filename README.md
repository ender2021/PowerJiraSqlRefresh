# PowerJiraSqlRefresh

This PowerShell module is designed to facilitate extracting data from a Jira Cloud instance for storage in an MS SQL Server (or other compatible) database.

### Prerequisites

To use this module, you must have a Jira Cloud instance available to extract data from, a system to run the PowerShell module, and an MS SQL Server (or compatible) database.

#### Jira Requirements
* You must have a Jira Cloud instance.
* The Jira account you use to access the instance must have access to read all the projects and issues you wish to extract.
* The Jira account you use must have an API token configured, and you must have the token (see [API Tokens](https://confluence.atlassian.com/cloud/api-tokens-938839638.html))

#### PowerShell Requirements
* PowerShell 6.1+ must be installed.
* The module [PowerJira](https://github.com/ender2021/PowerJira) must be installed.

#### Database Requirements
* The account executing the module must have access to an MS SQL Server (or compatible) database.
* If you plan to install the required database objects using the module, the account executing the module must have permission to create database objects.

### Installing

Step 1: Install the module from [PowerShell Gallery](https://www.powershellgallery.com)

```powershell
Install-Module PowerJiraSqlExecute
```

Step 2: Install database objects with PowerShell

```powershell
Import-Module PowerJiraSqlExecute

Install-JiraDatabase -SqlInstance localhost -SqlDatabase Jira -Username "DOMAIN\YourUserName"
```

Step 2 (alternate): Install database objects manually

1. Execute the scripts located at [/PowerJiraSqlRefresh/public/sql/](/PowerJiraSqlRefresh/public/sql/) against the database you will use with the module.
2. Add the user you will execute the module with to the role JiraRefreshRole:

```sql
ALTER ROLE [JiraRefreshRole] ADD MEMBER [DOMAIN\YourUserName]
```

### Usage

With the module and prerequisites installed and database objects in place, perform the following steps:

1. Import the module and its dependencies
2. Open a PowerJira Jira session
3. Call `Update-JiraSql` with your desired parameters
4. Close the PowerJira Jira session

For a working example implementation, see [PowerJiraSqlRefreshExecute](https://github.com/ender2021/PowerJiraSqlRefreshExecute)

For details on the available parameters, use `Get-Help Update-JiraSql -detailed`

```powershell
Import-Module PowerJira
Import-Module PowerJiraSqlExecute

$JiraCredentials = @{
    UserName="Your Jira Email"
    Password="Your Jira API Token"
    HostName="Your Jira Site URL"
}

$parameters = @{
    SqlInstance = "localhost"
    SqlDatabase = "Jira"
    RefreshType = (Get-JiraRefreshTypes).Differential
}

Open-JiraSession @JiraCredentials

Update-JiraSql @parameters

Close-JiraSession
```

## Authors

* **Justin Mead** - [ender2021](https://github.com/ender2021)

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details