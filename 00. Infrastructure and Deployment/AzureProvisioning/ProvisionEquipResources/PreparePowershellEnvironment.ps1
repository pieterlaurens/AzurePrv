# This script installs the required Azure modules for PowerShell, to run the other script.
Get-Module PowerShellGet -list | Select-Object Name,Version,Path

Install-Module AzureRM -AllowClobber

Import-Module AzureRM

Set-PSRepository

Import-Module AzureRM.DataFactoryV2