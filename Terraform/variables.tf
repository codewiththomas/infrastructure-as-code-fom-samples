variable "environment" {
  type = string
  default = "Development"
}

variable "resource_group_name" {
  type = string
  description = "The name the resource group will have."
  default = "demonstrationTerraformResourceGroup"
}

variable "location" {
  default = "westeurope"
}