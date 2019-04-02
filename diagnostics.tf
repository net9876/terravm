resource "random_id" "randomId" {
    keepers = {
        # Generate a new ID only when a new resource group is defined
        resource_group = "${azurerm_resource_group.rg.name}"
    }

    byte_length = 8
}

resource "azurerm_storage_account" "diagstorage" {
    name = "diag${random_id.randomId.hex}"
    resource_group_name = "${azurerm_resource_group.rg.name}"
    location = "${var.region}"
    account_kind = "StorageV2"
    account_tier = "Standard"
    account_replication_type = "LRS"
    tags = "${var.tags}"

}