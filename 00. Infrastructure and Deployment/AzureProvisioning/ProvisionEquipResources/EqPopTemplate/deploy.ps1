$VmResourceGroup = "equip-dev-rg"
$VmName = "equip-pop-vm"
$VmDiskName = "equip-pop-disk"
Login-AzureRmAccount;

$resourceProviders = @("microsoft.compute","microsoft.network");
if($resourceProviders.length) {
    Write-Host "Registering resource providers"
    foreach($resourceProvider in $resourceProviders) {
        Register-AzureRmResourceProvider -ProviderNamespace $resourceProvider
    }
}

# Create the VM resource group and create a VM from template
New-AzureRmResourceGroup -Name $VmResourceGroup -Location "West Europe"
New-AzureRmResourceGroupDeployment -ResourceGroupName $VmResourceGroup -TemplateFile "..\Templates\EntisSqlVm\template.json" -TemplateParameterFile "..\Templates\EntisSqlVm\parametersFile.json"

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
