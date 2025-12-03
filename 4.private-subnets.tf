resource "azurerm_subnet" "private_subnets" {
  count                = length(local.new_private_subnet_cidrs)
  name                 = "${var.vnet_name}-PrivateSubnet-${count.index + 1}"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.default.name
  address_prefixes     = [element(local.new_private_subnet_cidrs, count.index)]
}
