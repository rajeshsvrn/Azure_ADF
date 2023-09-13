terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {
    
  }
  client_id       = var.ARM_CLIENT_ID
  client_secret   = var.ARM_CLIENT_SECRET
  subscription_id = var.ARM_SUBSCRIPTION_ID
  tenant_id       = var.ARM_TENANT_ID
}


module "adf" {
  source = "./modules/adf"
  
  data_factory_name     = var.data_factory_name
  data_factory_location = var.data_factory_location
  resource_group_name   = var.resource_group_name
  depends_on = [ module.blob_storage_accounts ]
}



module "blob_storage_accounts" {
  source                  = "./modules/az_blob_storage"
  resource_group_name     = var.resource_group_name
  location                = var.location
  number_of_storage_accounts = var.number_of_storage_accounts
  storage_account_names   = var.storage_account_names
  container_names  = var.container_names
  blobs = var.blobs
}

# You can use the output values from the module if needed
output "storage_account_ids" {
  value = module.blob_storage_accounts.storage_account_ids
}


module "adf_linked_services" {
  source                = "./modules/adf_linked_service"
  data_factory_id     = "${module.adf.data_factory_id}"
  linked_service_names  = var.linked_service_names
  # Other variables for the linked service module
  storage_account_primary_connection_string = "${module.blob_storage_accounts.primary_connection_string}"

depends_on = [ module.blob_storage_accounts ]

}

# Define Datasets
resource "azurerm_data_factory_dataset_azure_blob" "source_dataset" {
  name                = "source_dataset"
  data_factory_id     = "${module.adf.data_factory_id}"
  linked_service_name = "${module.adf_linked_services.source_linked_name}"
  path         = "inputcontainer"
  filename         = "inputfile.csv"
}

resource "azurerm_data_factory_dataset_azure_blob" "destination_dataset" {
  name                = "destination_dataset"
  data_factory_id     = "${module.adf.data_factory_id}"
  linked_service_name = "${module.adf_linked_services.destination_linked_name}"
  path         = "outputcontainer"
  filename           = "outputfile.csv"
}

resource "azurerm_data_factory_pipeline" "copy_data" {
  name                = "copy_data_pipeline"
  data_factory_id     = "${module.adf.data_factory_id}"


  activities_json = jsonencode([
    {
      name = "CopyDataActivity",
      type = "Copy",
      inputs = [
        {
          reference_name = "source_dataset",
          type           = "DatasetReference",
        },
      ],
      outputs = [
        {
          reference_name = "destination_dataset",
          type           = "DatasetReference",
        },
      ],
      type_properties = {
        source = {
          type = "AzureBlobSource",
          // Define your source settings here
          blob_path       = "inputcontainer/inputfile.csv",
        },
        sink = {
          type = "AzureBlobSink",
          // Define your destination settings here
          blob_path       = "outputcontainer/outputfile.csv"
        },
      },
    },
    // Add more activities as needed
  ])

}