# Cluster AKS
resource "azurerm_kubernetes_cluster" "aks" {
  name                = local.aks.name
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  dns_prefix          = local.aks.name
  sku_tier            = local.aks.sku_tier

  default_node_pool {
    name           = local.aks.default_node_pool.name
    node_count     = local.aks.default_node_pool.node_count
    vm_size        = local.aks.default_node_pool.vm_size
    vnet_subnet_id = azurerm_subnet.aks_subnet.id
  }

  service_principal {
    client_id     = local.sp_client_id
    client_secret = local.sp_client_secret
  }

  network_profile {
    network_plugin = "azure"
    dns_service_ip = "10.2.0.10"
    service_cidr   = "10.2.0.0/16"
  } 

  tags = local.tags

    lifecycle {
    ignore_changes = [ default_node_pool[0].upgrade_settings ]
  }

}

# Saída com informações do cluster
output "kubernetes_cluster_name" {
  description = "Nome do cluster AKS"
  value       = azurerm_kubernetes_cluster.aks.name
}