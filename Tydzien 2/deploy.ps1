Connect-AzAccount

$rg = 'pt-nauka-01'
New-AzResourceGroup -Name $rg -Location 'NorthEurope' -Force

New-AzResourceGroupDeployment `
    -Name 'ARMDeployment' `
    -ResourceGroupName $rg `
    -TemplateFile '.\VNet.json' `
    -EnvironmentName 'az-303' `

New-AzResourceGroupDeployment `
    -Name 'VMDeployment' `
    -ResourceGroupName $rg `
    -TemplateFile '.\VM.json' `
    -VMName 'vmsql01' `
    -VNetName 'vnet-az-303-northeurope-01' `
    -SubnetName 'snet-az-303-backend-01'