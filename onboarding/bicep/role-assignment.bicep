param roleDefinitionId string
param principalType string
param principalId string

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(resourceGroup().id, roleDefinitionId, principalId)
  properties: {
    roleDefinitionId: roleDefinitionId
    principalType: principalType
    principalId: principalId
  }
}
