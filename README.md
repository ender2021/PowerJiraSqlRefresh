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

### Feature Configuration

PowerJiraSqlRefresh provides a handful of configuration options which can be supplied by the user at invocation.

#### Refresh Type

The module provides two refresh modes, Full and Differential.  When a Full refresh is performed, the database will be cleared of all extracted Jira data and the module will retrieve all instance data.  A Differential refresh will retrieve only the deltas since the last time the refresh process was executed.  Note that some tables will be fully updated, even in a Differential refresh, as the Jira Cloud REST API does not provide change tracking on all object types.

##### Differentially Refreshed Elements

These data elements can be refreshed differentially:

* Issues (Add/Update)
* Worklogs

##### Fully Refreshed Elements

These data elements are always fully refreshed, even during a Differential refresh:

* Projects
     * Versions
     * Components
* Project Categories
* Statuses
* Status Categories
* Resolutions
* Priorities
* Issue Link Types
* Users

#### Issue Obfuscation

Because data is retrieved from the Jira instance and stored in a SQL database, all data that is visible to the Jira user configured for the refresh process will  subsequently be visible to those who have access to the SQL database.  Recognizing that this may unintentionally expose sensitve information that has been secured in Jira by permissions, PowerJiraSqlRefresh provides an option to obfuscate ticket contents in specified Jira projects.  One or more project keys can be provided at execution time; issues within those projects will have their Summary and Description field contents replaced with the string `[Redacted]`

## Authors

* **Justin Mead** - [ender2021](https://github.com/ender2021)

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details