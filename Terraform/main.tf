# Configure the Azure provider
# List of all providers:
# https://registry.terraform.io/browse/providers
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm" //shorthand for registry.terraform.io/hashicorp/azurerm
      version = "~> 2.65"
    }
  }

  required_version = ">= 1.1.0"
}

provider "azurerm" {
  features {}
}



resource "azurerm_resource_group" "example" {
  name     = var.resource_group_name
  location = var.location
}



# Create a virtual network
resource "azurerm_virtual_network" "example" {
    name                = "myVirtualNetworkBicepTerraform"
    address_space       = ["10.0.0.0/16"]
    location            = var.location
    resource_group_name = azurerm_resource_group.example.name
}

# Create a subnet 
resource "azurerm_subnet" "example" {
  name                 = "mySubnetTerraform"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "example" {
  name                = "nic"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  ip_configuration {
    name                          = "vmPublicIpTerraform"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "example" {
  name                = "example-machine"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  size                = "Standard_F2"
  admin_username      = "vmuser"
  admin_password      = "P@ssword123!"
  network_interface_ids = [
    azurerm_network_interface.example.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
}