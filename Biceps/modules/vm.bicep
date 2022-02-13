/** Module to create a virtual machine.
 *
 *  Template description 
 *  https://docs.microsoft.com/en-us/azure/templates/microsoft.compute/virtualmachines
 *
 *  @author:  Thomas Bazan
 *  @created: 13.02.2022
 */

@description('The username for the admin user of the VM')
param username string

@description('Secure Password for the VM user')
@minLength(8)
@secure()
param password string

@description('Prefix of the VM name')
param vmName string

@description('Unique DNS Name for the Public IP used to access the Virtual Machine.')
param dnsLabelPrefix string = toLower('${vmName}-${uniqueString(resourceGroup().id, vmName)}')
param publicIpName string = 'vmPublicIpBicep'

@description('Available images can be checked with "az vm image list"')
@allowed([
  '2016-Datacenter'
  '2019-Datacenter'
  '2022-Datacenter'
])
param vmOperatingSystem string = '2019-Datacenter'

@description('Size of the virtual machine.')
param vmSize string = 'Standard_D2_v3'

param location string = resourceGroup().location

resource publicIp 'Microsoft.Network/publicIPAddresses@2021-05-01' = {
  name: publicIpName
  location: location
  sku:{
    name: 'Basic'
  }
  properties: {
    publicIPAllocationMethod: 'Dynamic'
    dnsSettings: {
      domainNameLabel: dnsLabelPrefix
    }
  }
}

resource securityGroup 'Microsoft.Network/networkSecurityGroups@2021-05-01' = {
  name: 'networksecuritygroupnamekdnkhjvsklhlv'
  location: location
  properties: {
    securityRules: [
      {
        name: 'default-allow-rdp-port-3389'
        properties: {
          access: 'Allow'
          direction: 'Inbound'
          protocol: 'Tcp'
          destinationPortRange: '3389'
          sourcePortRange: '*'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          priority: 1024
        }
      }
    ]
  }
}

var addressPrefix = '10.0.0.0/16'
resource virtualNetwork 'Microsoft.Network/virtualNetworks@2021-05-01' = {
  name: 'myVirtualNetworkBicep'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        addressPrefix
      ]      
    }
  }
}

resource subnet 'Microsoft.Network/virtualNetworks/subnets@2021-05-01' = {
  parent: virtualNetwork
  name: 'mySubnetBicep'
  properties: {
    addressPrefix: addressPrefix
    networkSecurityGroup: {
      id: securityGroup.id
    }
  }
}

resource networkInterface 'Microsoft.Network/networkInterfaces@2021-05-01' = {
  name: 'nic'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig001'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: publicIp.id
          }
          subnet: {
            id: subnet.id
          }
        }
      }
    ]
  }
}

resource vm 'Microsoft.Compute/virtualMachines@2021-11-01' = {
  name: vmName
  location: location
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    osProfile: {
      computerName: vmName
      adminUsername: username
      adminPassword: password
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: vmOperatingSystem
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: 'StandardSSD_LRS'
        }
      }
      dataDisks: [
        {
          diskSizeGB: 1023
          lun: 0
          createOption: 'Empty'
        }
      ]
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: networkInterface.id
        }
      ]
    }
  }
}

output hostname string = publicIp.properties.dnsSettings.fqdn

