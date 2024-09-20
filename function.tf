resource "azurerm_storage_account" "sa" {
  name                     = "skinastorage"
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags                     = local.tags
}

resource "azurerm_service_plan" "asp" {
  name                = "${local.function.name}-plan"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  os_type             = "Linux"
  sku_name            = local.function.sku_name
  tags                = local.tags
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/service_plan

resource "azurerm_linux_function_app" "fa" {
  name                = "${local.function.name}-app"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  storage_account_name       = azurerm_storage_account.sa.name
  storage_account_access_key = azurerm_storage_account.sa.primary_access_key
  service_plan_id            = azurerm_service_plan.asp.id

  enabled = true
  # virtual_network_subnet_id = ""

  site_config {
    # always_on = true
    # api_management_api_id = ""
  }

  tags = local.tags

  lifecycle {
    ignore_changes = [ app_settings ]
  }
  
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_function_app
