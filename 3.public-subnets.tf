resource "azurerm_subnet" "public_subnets" {
  count                = length(local.new_public_subnet_cidrs)
  name                 = "${var.vnet_name}-PublicSubnet-${count.index + 1}"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.default.name
  address_prefixes     = [element(local.new_public_subnet_cidrs, count.index)]

  # Tags are applied at the VNet level in Azure, not directly on subnets.
  # If you want tagging consistency, you can tag the VNet or NICs instead.
}
