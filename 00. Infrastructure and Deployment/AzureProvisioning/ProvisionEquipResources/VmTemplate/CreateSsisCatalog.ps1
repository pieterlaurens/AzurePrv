#sp_configure 'show advanced options', 1;  
#GO  
#RECONFIGURE;  
#GO  
#sp_configure 'clr enabled', 1;  
#GO  
#RECONFIGURE;  
#GO  

# Load the IntegrationServices Assembly
[Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.Management.IntegrationServices")

# Store the IntegrationServices Assembly namespace to avoid typing it every time
$ISNamespace = "Microsoft.SqlServer.Management.IntegrationServices"

Write-Host "Connecting to server ..."

# Create a connection to the server
$sqlConnectionString = "Data Source=52.174.0.212;Initial Catalog=master;Integrated Security=false;User ID = pieterlaurens; Password = charlott3!982;"
$sqlConnection = New-Object System.Data.SqlClient.SqlConnection $sqlConnectionString

# Create the Integration Services object
$integrationServices = New-Object $ISNamespace".IntegrationServices" $sqlConnection

# Provision a new SSIS Catalog
$catalog = New-Object $ISNamespace".Catalog" ($integrationServices, "SSISDB", "P@assword1")
$catalog.Create()