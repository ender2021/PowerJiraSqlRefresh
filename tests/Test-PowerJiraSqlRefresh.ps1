Import-Module $PSScriptRoot\..\PowerJiraSqlRefresh\PowerJiraSqlRefresh.psm1 -Force

# grab private functions from files
$privateFiles = Get-ChildItem -Path $PSScriptRoot\..\PowerJiraSqlRefresh\private -Recurse -Include *.ps1 -ErrorAction SilentlyContinue
if(@($privateFiles).Count -gt 0) { $privateFiles.FullName | ForEach-Object { . $_ } }

Invoke-Pester $PSScriptRoot -Show Failed, Summary