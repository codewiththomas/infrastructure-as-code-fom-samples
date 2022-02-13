# Infrastructure as code samples for Microsoft Azure

This repository contains the sample source code to the assignment **Infrastructure as Code in Azure Environments – An introduction of Bicep** in IT infrastructre at FOM university.

The source code is subdivided into three stand-alone projects. Each of them creates a resource group in Azure and deploys a ready-to-use virtual machine with its required network configuration.

## 1. Azure Resource Manager Template

This folder contains the transpiled version of the bicep template. ARM templates are JSON-files that can be deployed by [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/) or [Azure PowerShell module](https://docs.microsoft.com/en-us/powershell/azure/new-azureps-module-az).

## 2. Bicep Template

This folder contains the bicep files. In order to use them the following prerequisites have to be met:
- a [Azure subscription](https://azure.microsoft.com/free/) 
- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/) or [Azure PowerShell module](https://docs.microsoft.com/en-us/powershell/azure/new-azureps-module-az) 

## 3. Terraform Template

This folder contains the template files for Terraform. In order to use them, the following prerequisites must be met:
- a [Azure subscription](https://azure.microsoft.com/free/) 
- [Terraform CLI](https://learn.hashicorp.com/tutorials/terraform/install-cli?in=terraform/azure-get-started) needs to be installed