targetScope = 'subscription'

extension microsoftGraphV1

param appId string

resource servicePrincipal 'Microsoft.Graph/servicePrincipals@v1.0' existing = {
  appId: appId
}

output id string = servicePrincipal.id
