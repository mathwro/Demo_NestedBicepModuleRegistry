@description('The name of the storage account to create.')
param storageAccountName string

@description('The location where the storage account will be created.')
@allowed([
  'westeurope'
  'northeurope'
])
param location string

targetScope = 'resourceGroup'

resource storageAccount 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  properties: {
    accessTier: 'Hot'
    allowBlobPublicAccess: false
  }
  kind: 'StorageV2'
}
