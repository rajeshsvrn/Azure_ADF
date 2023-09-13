variable "data_factory_name" {
  description = "Name of the Azure Data Factory"
  type        = string
}

variable "data_factory_location" {
  description = "Location of the Azure Data Factory"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the Azure Resource Group"
  type        = string
}


variable "ARM_CLIENT_ID" {
  description = "Azure client ID"

}

variable "ARM_CLIENT_SECRET" {
  description = "Azure client secret"
}

variable "ARM_SUBSCRIPTION_ID" {
  description = "Azure subscription ID"

}

variable "ARM_TENANT_ID" {
  description = "Azure tenant ID"

}


# azure_blob_storage_module/variables.tf


variable "location" {
  description = "Azure region where resources will be created"
}

variable "number_of_storage_accounts" {
  description = "Number of storage accounts to create"
}

variable "storage_account_names" {
  description = "List of storage account names"
  type        = list(string)
}





#adf linked service varibles

variable "linked_service_names" {
  description = "List of storage account names"
  type        = list(string)
}



#container variable
variable "container_names" {
  description = "Names of the containers to create within each storage account"
  type        = list(string)
}


variable "blobs" {
  description = "Names of the containers to create within each storage account"
  type        = list(string)
}
