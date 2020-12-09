Connect-AzAccount

$rg = 'rg-learn-01'
New-AzResourceGroup -Name $rg -Location 'NorthEurope' -Force

$resourceGroupName = "AZ-303"
$storageAccountName = "ptstoragex"
$containerName = "arm"
$VNetfileName = "VNet.json" 
$VMfileName = "VM.json" 

$key = (Get-AzStorageAccountKey -ResourceGroupName $resourceGroupName -Name $storageAccountName).Value[0]
$context = New-AzStorageContext -StorageAccountName $storageAccountName -StorageAccountKey $key

$upn = Read-Host -Prompt "Enter your user principal name (email address) used to sign in to Azure"
$adUserId = (Get-AzADUser -UserPrincipalName $upn).Id
$VMAdminNameValue = Read-Host -Prompt "Enter the virtual machine administrator name" -AsSecureString
$VMAdminPasswordValue = Read-Host -Prompt "Enter the virtual machine administrator password" -AsSecureString

# Generate a SAS token
$VNetLinkedTemplateUri = New-AzStorageBlobSASToken `
    -Context $context `
    -Container $containerName `
    -Blob $VNetfileName `
    -Permission r `
    -ExpiryTime (Get-Date).AddHours(2.0) `
    -FullUri

$VMLinkedTemplateUri = New-AzStorageBlobSASToken `
    -Context $context `
    -Container $containerName `
    -Blob $VMfileName `
    -Permission r `
    -ExpiryTime (Get-Date).AddHours(2.0) `
    -FullUri

# Deploy the template
New-AzResourceGroupDeployment `
  -Name 'DeployLinkedTemplate' `
  -ResourceGroupName $rg `
  -TemplateFile '.\Main.json' `
  -VNetTemplateUri $VNetLinkedTemplateUri `
  -VMTemplateUri $VMLinkedTemplateUri `
  -VM1Name 'vm-WebServer-01' `
  -VM2Name 'vm-SQLServer-01' `
  -EnvironmentName 'az-303' `
  -KeyVaultName 'kv-az-303' `
  -VMUserNameSecret $VMAdminNameValue `
  -VMUserPasswordSecret $VMAdminPasswordValue `
  -AdUserId $adUserId