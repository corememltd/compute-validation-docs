targetScope = 'subscription'

@description('Name of Resource Group to deploy the Cloud Validation resource to')
param resourceGroupName string = 'OnboardComputeValidation'

// https://github.com/Azure/bicep/issues/19278
@description('Location to deploy resources to')
@allowed([
  'southcentralus'
  'eastus2euap'
])
param location string = any(deployment().location)

@description('Name of cloud validation resource to be placed in the RG provided by resourceGroupName')
param cloudValidationName string = 'cv-${utcNow('yyyyMMddHHmmss')}'

@description('Name of cloud validation execution plan name')
param executionPlanName string = 'cvep'

@description('Name of cloud validation execution plan run name')
param executionPlanRunName string = 'cveprun'

@description('OS type of the VM image.')
@allowed([
  'Linux'
  'Windows'
])
param osType string = 'Linux'

@description('CPU architecture')
@allowed([
  'X64'
  'Arm64'
])
param architectureType string = 'X64'

@description('VM generation')
@allowed([
  'V1'
  'V2'
])
param vmGenerationType string = 'V2'

@description('OS state of the VM image')
@allowed([
  'Generalized'
  'Specialized'
])
param osState string = 'Generalized'

@description('VHD SAS URI of base disk image (supports Storage Account and Disk Image URIs)')
param vhdSasUri string

@description('Client Application ID of Compute Validation Service (recommended you do not change this)')
param appId string = 'f877b90d-59ee-40e3-8d2c-215dae4c80d8'

// HACK: seems to be hardcoded in the backend
var managedResourceGroupName = '${cloudValidationName}-mrg'

var contributorId = subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
var storageBlobDataContributorId = subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'ba92f5b4-2d11-453d-a403-e96b0029c9fe')

module servicePrincipal 'service-principal.bicep' = {
  name: 'service-principal'
  params: {
    appId: appId
  }
}

resource resourceGroup 'Microsoft.Resources/resourceGroups@2025-04-01' = {
  name: resourceGroupName
  location: location
}

resource managedResourceGroup 'Microsoft.Resources/resourceGroups@2025-04-01' = {
  #disable-next-line use-stable-resource-identifiers
  name: managedResourceGroupName
  // we do this to avoid bouncing off another module
  managedBy: resourceId(subscription().subscriptionId, resourceGroupName, 'Microsoft.Validate/cloudValidations', cloudValidationName)
  location: location
  dependsOn: [
    cloudValidation
  ]
}

module roleAssignmentContributor 'role-assignment.bicep' = {
  name: 'role-assignment-contributor'
  scope: managedResourceGroup
  params: {
    roleDefinitionId: contributorId
    principalType: 'ServicePrincipal'
    principalId: servicePrincipal.outputs.id
  }
}
module roleAssignmentStorageBlobDataContributor 'role-assignment.bicep' = {
  name: 'role-assignment-storage-blob-data-contributor'
  scope: managedResourceGroup
  params: {
    roleDefinitionId: storageBlobDataContributorId
    principalType: 'ServicePrincipal'
    principalId: servicePrincipal.outputs.id
  }
}

module cloudValidation 'cloud-validation.bicep' = {
  name: cloudValidationName
  scope: resourceGroup
  params: {
    location: location
    cloudValidationName: cloudValidationName
  }
}

module cloudValidationPlan 'cloud-validation-plan.bicep' = {
  name: '${cloudValidationName}-plan-and-execute'
  scope: resourceGroup
  dependsOn: [
    managedResourceGroup
    roleAssignmentContributor
    roleAssignmentStorageBlobDataContributor
  ]
  params: {
    location: location
    cloudValidationName: cloudValidationName
    executionPlanName: executionPlanName
    executionPlanRunName: executionPlanRunName
    osType: osType
    osState: osState
    architectureType: architectureType
    vhdSasUri: vhdSasUri
    vmGenerationType: vmGenerationType
  }
}

output cloudValidationId string = cloudValidation.outputs.id
output managedResourceGroupName string = managedResourceGroupName
