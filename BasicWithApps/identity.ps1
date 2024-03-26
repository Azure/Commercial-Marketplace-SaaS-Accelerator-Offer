#https://learn.microsoft.com/en-us/samples/azure/azure-quickstart-templates/deployment-script-azcli-graph-azure-ad/ 
Param(  
   [string][Parameter()][Alias('n')]$identityName = "saas-accelerator-deploy-identity",
   [string][Parameter()][Alias('g')]$resourceGroup = 'default-saas-deploy-rg',
   [string][Parameter()][Alias('l')]$location = "eastus"
)

az group create -g $resourceGroup -l $location -o none

$graphApp = (az ad sp list --filter "appId eq '00000003-0000-0000-c000-000000000000'" --query "{ appRoleId: [0] .appRoles [?value=='Application.ReadWrite.All'].id | [0], objectId:[0] .id }" -o json) | ConvertFrom-Json

$newSp = (az identity create -n $identityName -g $resourceGroup) | ConvertFrom-Json

az rest -m post --headers "Content-Type=application/json" -u "https://graph.microsoft.com/v1.0/servicePrincipals/$($newSp.principalId)/appRoleAssignedTo" -b "{'appRoleId' : '$($graphApp.appRoleId)','principalId': '$($newSp.principalId)','resourceId': '$($graphApp.objectId)'}"
