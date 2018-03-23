$RecreateFileshare = $false
$FileShareResourceGroup = "EdXFileshare"
$FileShareStorageAccount = "edxexptfileshare"
$FileShareName = "sourcefiles"
$FileShareFolder = "CpcXml"
$SourceDirectoryToCopy = "C:\Users\pbaljon\Downloads\CPCSchemeXML201801"

$VmResourceGroup = "EdX"
$VmName = "edXTraining"
$VmDiskName = "EdXData"
#Login-AzureRmAccount;

# Create a resource group for the file share, and a file share in it
If($RecreateFileshare){
    New-AzureRmResourceGroup -Name $FileShareResourceGroup -Location "West Europe"
    New-AzureRmStorageAccount -ResourceGroupName $FileShareResourceGroup -AccountName $FileShareStorageAccount -Location "West Europe" -SkuName Standard_LRS
    $accountkey = (Get-AzureRmStorageAccountKey -Name $FileShareStorageAccount -ResourceGroupName $FileShareResourceGroup).Value[0] # Value[0] gets key1.

    $context = New-AzureStorageContext -StorageAccountName $FileShareStorageAccount -StorageAccountKey $accountkey
    New-AzureStorageShare –Name sourcefiles –Context $context
    New-AzureStorageDirectory -ShareName $FileShareName -Context $context –Path $FileShareFolder

    # Copy files into the file share from local disk --> This directory is created from https://www.cooperativepatentclassification.org/cpc/interleaved/CPCSchemeXML201801.zip
    $CurrentFolder = (Get-Item $SourceDirectoryToCopy).FullName
    $Container = Get-AzureStorageShare -Name $FileShareName -Context $context

    Get-ChildItem -Path $CurrentFolder -Recurse | Where-Object { $_.GetType().Name -eq "FileInfo"} | ForEach-Object {
        $path=$_.FullName.Substring($Currentfolder.Length+1).Replace("\","/")
    
        Set-AzureStorageFileContent -Share $Container -Source $_.FullName -Path $FileShareFolder -Force
        }
    }

$resourceProviders = @("microsoft.compute","microsoft.network");
if($resourceProviders.length) {
    Write-Host "Registering resource providers"
    foreach($resourceProvider in $resourceProviders) {
        Register-AzureRmResourceProvider -ProviderNamespace $resourceProvider
    }
}

# Create the VM resource group and create a VM from template
New-AzureRmResourceGroup -Name $VmResourceGroup -Location "West Europe"
New-AzureRmResourceGroupDeployment -ResourceGroupName $VmResourceGroup -TemplateFile "Templates\EntisSqlVm\template.json" -TemplateParameterFile "Templates\EntisSqlVm\parametersFile.json"

# Add a data disk to the VM
#$VM = Get-AzureRmVM -Name $VmName -ResourceGroupName $VmResourceGroup
#Add-AzureRmVMDataDisk -VM $VM -Name $VmDiskName -DiskSizeInGB 1 -CreateOption empty -Lun 0
#Update-AzureRmVM -VM $VM -ResourceGroupName $VmResourceGroup

# Copy files from the file share
$domainUser = "NL_SC_Eng_PPU_DC@entis.ai"
$domainPassword = "An8MYChKvrd"
$parametersFilePath = "Templates\EntisSqlVm\parametersFile.json"
if(Test-Path $parametersFilePath) {
       Write-Host "Joining entis.ai domain."
       $json = Get-Content $parametersFilePath | Out-String | ConvertFrom-Json

       $string1 = "{
             ""Name"": ""entis.ai"",
             ""User"": ""$domainUser"",
             ""Restart"": ""true"",
             ""Options"": ""3""
       }"
       $string2 = "{ ""Password"": ""$domainPassword"" }"

       Set-AzureRmVMExtension -ResourceGroupName $VmResourceGroup -ExtensionType "JsonADDomainExtension" -Name "joindomain" -Publisher "Microsoft.Compute" -TypeHandlerVersion "1.0" -VMName $json.parameters.virtualMachineName.value -Location $json.parameters.location.value -SettingString $string1 -ProtectedSettingString $string2
             
       Get-AzureRmVMExtension -Name "joindomain" -ResourceGroupName $VmResourceGroup -VMName $json.parameters.virtualMachineName.value -Status

       Get-AzureRmNetworkInterface -ResourceGroupName $VmResourceGroup | ForEach { $IPs = $_ | Get-AzureRmNetworkInterfaceIpConfig | Select PrivateIPAddress; Write-Host $IPs.PrivateIPAddress }
} 
