﻿#
# Script.ps1
#
# input: target server, SSIS project name (PRV/PRV-dev)
# Set-ExecutionPolicy RemoteSigned
Import-Module SqlServer

Write-Output "==================== Preparation: Setting global variables"
#$TargetSqlServer   = "equip-pop-vm"#$args[0] # nlams00859, nlagpdatacore, etc.
#$BuildConfiguration = "Release"#$args[1] #Release or Debug; only applies to project DB
#$BuildVersion = 1#$args[2]

$TargetSqlServer   = $args[0] # nlams00859, nlagpdatacore, etc.
$BuildConfiguration = $args[1] #Release or Debug; only applies to project DB
$BuildVersion = $args[2]


#param([string]$TargetSqlServer="nlams00859")# $args[0] # nlams00859, nlagpdatacore, etc.
#param([string]$BuildConfiguration="Release")# $args[0] # nlams00859, nlagpdatacore, etc.
#param([Int32]$BuildVersion=0)# $args[0] # nlams00859, nlagpdatacore, etc.

#$sqlPackage = "C:\Program Files (x86)\Microsoft SQL Server\130\DAC\bin\sqlpackage.exe"
$sqlPackage = "C:\Program Files (x86)\Microsoft Visual Studio\2017\SQL\Common7\IDE\Extensions\Microsoft\SQLDB\DAC\140\sqlpackage.exe"

# 1b. publish Data Handler
Write-Output "==================== Step 1: Publish Data Handlers DB"
$dthDacPacSource = "04. Storage schema\02. SQL Server\CentralViewsDB-AzurePoP\CentralViewsDB\bin\Release\CentralViewsDB.dacpac"
$dthProfile = "04. Storage schema\02. SQL Server\CentralViewsDB-AzurePoP\CentralViewsDB\CentralViewsDB.azurevm.publish.xml"
Invoke-Sqlcmd -Query "IF(DB_ID('prv_tst_dth') is not null) BEGIN alter database prv_tst_dth set single_user with rollback immediate; DROP DATABASE prv_tst_dth END" -ServerInstance $TargetSqlServer
& $sqlPackage /Action:Publish /tsn:"$TargetSqlServer" /tdn:prv_tst_dth /sf:$dthDacPacSource /profile:$dthProfile  /v:BuildVersion=$BuildVersion

# 5. Copy ProjectDb component dacpacs to target server
Write-Output "==================== Step 2: Publish project datamart"
$projectDbProfile = "01. Main\97. ProjectDatamart"
$ProjectDbModules = @("Landscape","Longlist","Questionnaire","Bacmap")
Invoke-Sqlcmd -Query "IF(DB_ID('prv_prj_unittest') is not null) BEGIN alter database prv_prj_unittest set single_user with rollback immediate; DROP DATABASE prv_prj_unittest END" -ServerInstance $TargetSqlServer
foreach($ModuleName in $ProjectDbModules){
	Write-Output "===$ModuleName"
    $moduleDacPacSource = "97. ProjectDatamart\$ModuleName\bin\$BuildConfiguration\ProjectDb$ModuleName.dacpac"
    $moduleProfile = "97. ProjectDatamart\$ModuleName\bin\$BuildConfiguration\ProjectDb$ModuleName.publish.xml"
	if($ModuleName -eq "Bacmap"){
		& $sqlPackage /Action:Publish /tsn:"$TargetSqlServer" /tdn:prv_prj_unittest /sf:$moduleDacPacSource /profile:$moduleProfile /v:DataHandlerDb=prv_tst_dth /v:ProjectDbQuestionnaire=prv_prj_unittest
	} else {
		& $sqlPackage /Action:Publish /tsn:"$TargetSqlServer" /tdn:prv_prj_unittest /sf:$moduleDacPacSource /profile:$moduleProfile
	}
}