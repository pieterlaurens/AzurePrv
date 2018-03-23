# Server names are hard coded. Debug deploys to 00859, Release to 00872, i.e. the cluster/availability group
# For the deployment to work, the target server must have a folder C:\SsisDlls\, shared under that name.
# The following user groups should have read/write access to that share
#	- NL\NL-Adm Deloitte Engine Admins
#	- NL\DataCore DeloitteEngine Users Secure
# The deployment is a two-step process: 1) copy the file to the shared folder, 2) call a remote procedure on that server to add a local .DLL file to its GAC.

# programma dat hem aanroept
# account dat hem aanroept (fholwerda, kwesseling, pbaljon)
if($env:UserName -eq "fholwerda" -or $env:UserName -eq "kwesseling" -or $env:UserName -eq "pbaljon"){
	$ConfigurationName = $args[0]
	$Source = $args[1]
	$PackageDll = $args[2]
	$ToServer = "NLAMS00859"
	if ($ConfigurationName -eq "Release")
	{
		$ToServer = "NLAMS00872"
	}
	$Target = "\\$ToServer\SsisDlls"

	Write-Output "Deploying to $ToServer for Karel, Freddy & PL. You are: $env:UserName" 


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

		#Remove from GAC using GacRemove method (Provide full path to the assembly in GAC)
		#$publish.GacRemove($Assembly)

		#Install dll into GAC using GacInstall method (Provide full path to the assembly)
		$publish.GacInstall($Assembly);
	}

	Write-Output "========================================"
	Write-Output "Will add $PackageDll to local GAC now."
	$sb.invoke($Source)

	Write-Output "========================================"
	Write-Output "Will copy and remote-install $PackageDll on $ToServer now."
	copy $Source $Target

	$cred = Get-Credential -Message "Enter the credentials for your admin account to allow a remote-install of the Deloitte.PipelineFramework.dll into the GAC."
	Invoke-Command -ComputerName $ToServer -Credential $cred -ScriptBlock $sb -ArgumentList "C:\SsisDlls\$p1$PackageDll"

	Write-Output "========================================"

	#to run this script: powershell.exe -noprofile -executionpolicy RemoteSigned -file "ABSOLUTEPATHNAARDITBESTAND\GACInstall.ps1"
} else {
	Write-Output "No post-build actions for user accounts other than Karel, Freddy & PL. You are: $env:UserName" 
	}