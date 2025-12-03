resource "azurerm_linux_virtual_machine" "webservers" {
  count               = 3
  name                = "${var.vnet_name}-PublicServer-${count.index + 1}"
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = lookup(var.instance_size, local.new_environment)
  admin_username      = var.admin_username
  network_interface_ids = [azurerm_network_interface.web_nic[count.index].id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  # Use custom image from Shared Image Gallery
  source_image_id = data.azurerm_shared_image_version.latest.id

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.ssh_public_key
  }

  tags = {
    Name              = "${var.vnet_name}-PublicServer-${count.index + 1}"
    Terraform-Managed = "Yes"
    Env               = local.new_environment
    ProjectID         = local.projid
    ManagedBy         = "Terraform"
  }
}
