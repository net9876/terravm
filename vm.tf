resource "azurerm_network_interface" "vm" {
    name                = "${var.vmname}-nic"
    location            = "${var.region}"
    resource_group_name = "${azurerm_resource_group.rg.name}"
    network_security_group_id = "${azurerm_network_security_group.linux.id}"

    ip_configuration {
        name                          = "NicConfiguration"
        subnet_id                     = "${azurerm_subnet.vm.id}"
        private_ip_address_allocation = "dynamic"
        public_ip_address_id          = "${azurerm_public_ip.vm.id}"
    }
	tags = "${var.tags}"
}

resource "azurerm_virtual_machine" "terraformvm" {
    name                  = "${var.vmname}"
    location              = "${var.region}"
    resource_group_name   = "${azurerm_resource_group.rg.name}"
    network_interface_ids = ["${azurerm_network_interface.vm.id}"]
    vm_size               = "Standard_DS1_v2"

    storage_os_disk {
        name              = "${var.vmname}-osDisk"
        caching           = "ReadWrite"
        create_option     = "FromImage"
        managed_disk_type = "Premium_LRS"
    }

    storage_image_reference {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "16.04.0-LTS"
        version   = "latest"
    }

    os_profile {
        computer_name  = "${var.vmname}"
        admin_username = "azureuser"
    }

    os_profile_linux_config {
        disable_password_authentication = true
        ssh_keys {
            path     = "/home/azureuser/.ssh/authorized_keys"
            # Before apply to change public key on your own
            key_data = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC3GaAuD1y7+CyvpEg4ZykGifAOKepzcl2kwmb6MbzwOU6NddfB8eBkCNlWmnDnFcVmDFaT9GfKDOBaPNR7sznXeKbSd+mrPIle07jSQqcA6Lh4DKcDGdOEJICpuJJPANp5Lf4OMbWGed2Vxco2oc4iH3abjuLZ7ddaMG824thCnqFdjC7UDwa5nRA5hf2jOenFQOKZ3A5/ekfsUhpjXQpsA+EOdZyWifyu+29t4bfzcS+E9UcUEiYqFMQ401DkLOfhUACfWxl2NYvxsD1AAGib9FQCSu85BsN0M5JVGdEdOzFcA7BLfPGfskZQWi2Wg6iEBlAbyg90MoBBna5MHMpX"
        }
    }

# Boot diagnostic, if nesesssary, to uncomment
#    boot_diagnostics {
#       enabled     = "true"
#        storage_uri = "${azurerm_storage_account.diagstorage.primary_blob_endpoint}"
#   }
#
#    tags = "${var.tags}"

}