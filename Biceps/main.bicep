/** The Script creates a new resource group in Microsoft Azure. Within this resource group
 *  a server is set up that runs SqlServer 
 *
 *  @author:  Thomas Bazan
 *  @created: 13.02.2022
 */
targetScope = 'subscription'

@description('Define if deployment should be in production or development mode')
@allowed([
  'Production'
  'Development'
])
param environment string = 'Development'

@description('Geographic Azure location')
param location string = deployment().location

//in case of development mode a suffix will be added to the name of the resource group
var environmentSuffix = (environment == 'Production') ? '' : 'Dev'
var resourceGroupName = 'demonstrationBicepResourceGroup${environmentSuffix}'

resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: location
}

//add a virtual machine to the resource group
module virtualMachine 'modules/vm.bicep' = {
  name: 'vm'
  scope: resourceGroup
  params: {    
    location: location
    username: 'vmuser'
    password: 'P@ssword123!'
    vmName: 'bicepTestVM'
  }
}

//output hostname001 string = vm001.outputs.hostname
//output hostname002 string = vm002.outputs.hostname
