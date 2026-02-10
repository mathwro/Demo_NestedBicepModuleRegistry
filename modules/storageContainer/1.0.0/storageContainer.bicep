targetScope = 'resourceGroup'

@description('The name of the storage account to create.')
param storageAccountName string

@description('The location where the storage account will be created.')
@allowed([
  'westeurope'
  'northeurope'
])
param location string


@description('The name of the storage container to create.')
param storageContainerName string

module storageAccountModule 'br:demoname.azurecr.io/resources/storageaccount:latest' = {
  name: 'storageAccountDeployment'
  params: {
    storageAccountName: storageAccountName
    location: location
  }
}

resource storageContainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2022-09-01' = {
  name: '${storageAccountName}/default/${storageContainerName}'
  properties: {
    publicAccess: 'None'
  }
}
