data_factory_name     = "my-data-factory-demo-rg1"
data_factory_location = "East US"
resource_group_name   = "my-resource-group"

ARM_CLIENT_ID=
ARM_CLIENT_SECRET=
ARM_SUBSCRIPTION_ID=
ARM_TENANT_ID=

#Storage values

location                = "East US"
number_of_storage_accounts = 2
storage_account_names   = ["sourceazdemo", "destinationazdemo"]
container_names = [ "inputcontainer", "outputcontainer" ]
blobs = ["inputfile.csv", "outputfile.csv"]

#ADF Linked service

linked_service_names  = ["source-storage", "destination-storage"]



