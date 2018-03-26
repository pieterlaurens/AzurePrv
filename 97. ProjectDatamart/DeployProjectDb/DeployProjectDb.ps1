$ProjctServer   = $args[0] # nlams00859, nlagpdatacore, etc.
$ProjectCatalog = $args[1] # prv_prj_projectname
$ModuleName     = $args[2] # ProjectDbCustom, Hotness, Landscape etc.

# $sqlpackage = "C:\Program Files (x86)\Microsoft SQL Server\110\DAC\bin\sqlpackage.exe"

$sqlPackage = "C:\Program Files (x86)\Microsoft SQL Server\130\DAC\bin\sqlpackage.exe"
$dacPacSource = "C:\Users\pbaljon\Documents\source\PRV\01. Main\97. ProjectDatamart\$ModuleName\bin\Release\ProjectDb$ModuleName.dacpac"
if($Host -eq "nlams00859" -or $Host -eq "nlams00872")
{
	$sqlPackage = "C:\Program Files (x86)\Microsoft SQL Server\110\DAC\bin\sqlpackage.exe"
}

& $sqlPackagAction:Publish /tsn:$ProjctServer /tdn:$ProjectCatalog /sf:$dacPacSource