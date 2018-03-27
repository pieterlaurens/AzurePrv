#
# Script.ps1
#
# input: target server, SSIS project name (PRV/PRV-dev)
Write-Output "==================== Preparation: Setting global variables"
$TargetServer       = $args[0] # nlams00859, nlams00872, etc.
$BuildConfiguration = $args[1] #Release or Debug; only applies to project DB
$BuildVersion       = $args[2]
$TargetSqlServer    = $args[3]

$TargetDlls = "\\$TargetServer\F$\dlls"
$TargetBinaries = "\\$TargetServer\F$\PrvAnalytics\bin"


#$sqlPackage = "C:\Program Files (x86)\Microsoft SQL Server\120\DAC\bin\sqlpackage.exe"
$sqlPackage = "C:\Program Files (x86)\Microsoft Visual Studio\2017\SQL\Common7\IDE\Extensions\Microsoft\SQLDB\DAC\140\sqlpackage.exe"
$isDeploymentWizard = "C:\Program Files (x86)\Microsoft SQL Server\140\DTS\Binn\ISDeploymentWizard.exe" 
$sqlCommand = "C:\Program Files (x86)\Microsoft SQL Server\Client SDK\ODBC\130\Tools\Binn\sqlcmd.exe"

# 1. publish Platform components and Platform handlers from ispac's to target server's SSIS catalog (in appropriate PRV or PRV-dev subfolder)
# This step needs to happen first, as the isdeploymentwizard returns immediately, and we want to write thebuild version after completion.
$platformHandlersIsPac = "03. Pipeline\01. SSIS-AzurePoP\PlatformHandlers\bin\Development\PlatformHandlers.ispac"
$platformComponentsIsPac = "03. Pipeline\01. SSIS-AzurePoP\PlatformComponents\bin\Development\PlatformComponents.ispac"
Write-Output "==================== Step 1a: Publish Platform Handlers .ispac"
& $isDeploymentWizard /Silent /SourcePath:$platformHandlersIsPac /DestinationServer:$TargetServer /DestinationPath:"/SSISDB/PRV-dev/PlatformHandlers"
Write-Output "==================== Step 1b: Publish Platform Components .ispac"
& $isDeploymentWizard /Silent /SourcePath:$platformComponentsIsPac /DestinationServer:$TargetServer /DestinationPath:"/SSISDB/PRV-dev/PlatformComponents"

# 2a. publish platform DB; set SSIS project name (PRV or PRV-dev) and deployment server
Write-Output "==================== Step 2a: Publish Platform DB"
$platformDacPacSource = "04. Storage schema\02. SQL Server\PlatformDB-AzurePoP\bin\Release\PlatformDB.dacpac"
$platformProfile = "04. Storage schema\02. SQL Server\PlatformDB-AzurePoP\PlatformDB.dev.publish.xml"
& $sqlPackage /Action:Publish /tsn:$TargetServer /tdn:prv_dev_inh /sf:$platformDacPacSource /profile:$platformProfile /v:DeploymentServer=$TargetSqlServer /v:BuildVersion=$BuildVersion

# 2b. publish Data Handler
Write-Output "==================== Step 2b: Publish Data Handlers DB"
$dthDacPacSource = "04. Storage schema\02. SQL Server\CentralViewsDB-AzurePoP\CentralViewsDB\bin\Release\CentralViewsDB.dacpac"
$dthProfile = "04. Storage schema\02. SQL Server\CentralViewsDB-AzurePoP\CentralViewsDB\CentralViewsDB.azurevm.publish.xml"
& $sqlPackage /Action:Publish /tsn:$TargetServer /tdn:prv_dev_dth /sf:$dthDacPacSource /profile:$dthProfile /v:BuildVersion=$BuildVersion

# # 3. publish Pipeline test suite by copying to target server's shared folder
# Write-Output "==================== Step 3: Copy test suite executables"
& xcopy /Y "98. Testing\PipelineTestSuite\PipelineTestSuite\bin\Release\*.exe" "$TargetBinaries\TestSuite"
& xcopy /Y "98. Testing\PipelineTestSuite\PipelineTestSuite\bin\Release\*.dll" "$TargetBinaries\TestSuite"

# 4. load Pipeline Framework to target server's GAC <-- required _admin credentials.
$sb = {
	param($Assembly)
	Write-Output "Assembly = $Assembly"

 	#Load System.EnterpriseServices assembly as it contain classes to handle GAC
 	[Reflection.Assembly]::LoadWithPartialName("System.EnterpriseServices")
  
 	#Create instance of Publish class which can handle GAC Installation and/or removal
 	[System.EnterpriseServices.Internal.Publish] $publish = new-object System.EnterpriseServices.Internal.Publish;
  
 	$LoadedAssembly = [System.Reflection.Assembly]::LoadFile($Assembly)
  
 	if ($LoadedAssembly.GetName().GetPublicKey().Length -eq 0) 
 	{
 		#throw "The assembly '$Assembly' must be strongly signed."
 		Write-Host "Assembly file" $Assembly "must be strongly signed...."
 		break 
 	}
 
 	#Install dll into GAC using GacInstall method (Provide full path to the assembly)
 	$publish.GacInstall($Assembly);
 }
 
 Write-Output "==================== Step 4a: Copy Pipeline framework to $TargetLocation"
 xcopy /Y "Deloitte.PipelineFramework-AzurePoP\bin\Release\Deloitte.PipelineFramework.dll" $TargetLocation
 Write-Output "==================== Step 4b: Remote-deploy framework to GAC"
 Invoke-Command -ComputerName $TargetServer -ScriptBlock $sb -ArgumentList "f:\dlls\Deloitte.PipelineFramework.dll"
 
 # 5. Copy ProjectDb component dacpacs to target server
 Write-Output "==================== Step 5: Copy project datamart binaries to $TargetServer"
 & xcopy /Y /S "97. ProjectDatamart\*.dacpac" "$TargetBinaries\ProjectDbDacpacs"
 & xcopy /Y /S "97. ProjectDatamart\*.xml" "$TargetBinaries\ProjectDbDacpacs"
 & xcopy /Y /S "97. ProjectDatamart\*.dll" "$TargetBinaries\ProjectDbDacpacs"
 

Write-Output "==================== Waiting 20 seconds before writing build version into SSIS project description"
Start-Sleep -s 20
& $sqlCommand -S $TargetSqlServer -v BuildNumber="$BuildVersion" -v ProjectName="PlatformHandlers" -v EnvironmentName="PRV-dev" -i "00. Infrastructure and Deployment\DeployPrv\SetSsisBuildNumber.sql"
& $sqlCommand -S $TargetSqlServer -v BuildNumber="$BuildVersion" -v ProjectName="PlatformComponents" -v EnvironmentName="PRV-dev" -i "00. Infrastructure and Deployment\DeployPrv\SetSsisBuildNumber.sql"


