# Private Route Table
resource "azurerm_route_table" "private" {
  name                = "${var.vnet_name}-Private-RT"
  location            = var.location
  resource_group_name = var.resource_group_name

  # No direct Internet route here; outbound handled via NAT Gateway association
  tags = {
    Name              = "${var.vnet_name}-Private-RT"
    Terraform-Managed = "Yes"
    Env               = local.new_environment
    ProjectID         = local.projid
  }
}

# Associate private route table with private subnets
resource "azurerm_subnet_route_table_association" "private" {
  count          = length(local.new_private_subnet_cidrs)
  subnet_id      = azurerm_subnet.private_subnets[count.index].id
  route_table_id = azurerm_route_table.private.id
}

# NAT Gateway for outbound internet (optional, like AWS NAT Gateway)
resource "azurerm_nat_gateway" "private_nat" {
  name                = "${var.vnet_name}-natgw"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name            = "Standard"

  tags = {
    Name              = "${var.vnet_name}-NATGW"
    Terraform-Managed = "Yes"
    Env               = local.new_environment
    ProjectID         = local.projid
  }
}

resource "azurerm_nat_gateway_public_ip_association" "private_nat_assoc" {
  nat_gateway_id       = azurerm_nat_gateway.private_nat.id
  public_ip_address_id = azurerm_public_ip.default.id
}

resource "azurerm_subnet_nat_gateway_association" "private_subnet_nat_assoc" {
  count        = length(local.new_private_subnet_cidrs)
  subnet_id    = azurerm_subnet.private_subnets[count.index].id
  nat_gateway_id = azurerm_nat_gateway.private_nat.id
}
