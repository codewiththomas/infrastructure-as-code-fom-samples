param location string = resourceGroup().location
param sqlServerName string
param sqlDatabaseName string

resource sqlServer 'Microsoft.Sql/servers@2021-08-01-preview' = {
  name: sqlServerName
  location: location
  properties: {
    administratorLogin: 'IamAdmin'
    administratorLoginPassword: 'P@ssword123!'     
  }
}

resource sqlDatabase 'Microsoft.Sql/servers/databases@2021-08-01-preview' = {
  name: '${sqlServer.name}/${sqlDatabaseName}'
  location: location
  sku: {
    name: 'Standard'
    tier: 'Standard'
  }
}
