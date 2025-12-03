# Existing VNets (like aws_vpc data sources)
data "azurerm_virtual_network" "default_vnet" {
  name                = "default-vnet"
  resource_group_name = "rg-default"
}

data "azurerm_virtual_network" "ansible_vnet" {
  name                = "ansible-vnet"
  resource_group_name = "rg-ansible"
}

# VNet Peering from default to ansible
resource "azurerm_virtual_network_peering" "default_to_ansible" {
  name                      = "default-to-ansible"
  resource_group_name       = data.azurerm_virtual_network.default_vnet.resource_group_name
  virtual_network_name      = data.azurerm_virtual_network.default_vnet.name
  remote_virtual_network_id = data.azurerm_virtual_network.ansible_vnet.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = false
}

# VNet Peering from ansible to default
resource "azurerm_virtual_network_peering" "ansible_to_default" {
  name                      = "ansible-to-default"
  resource_group_name       = data.azurerm_virtual_network.ansible_vnet.resource_group_name
  virtual_network_name      = data.azurerm_virtual_network.ansible_vnet.name
  remote_virtual_network_id = data.azurerm_virtual_network.default_vnet.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = false
}
