locals {
  resource_group_name = "skina-lanches-rg"
  location            = "East US2"
  subscription_id     = "dd1b3041-17d1-49c4-854c-696224d72fb5"
  tenant_id           = "39eafb87-49d3-46eb-82b1-867b38750ebe"
  sp_client_id        = "923add4d-e2f6-434d-a11d-0e763d7046d6"

  cosmosdb = {
    account_name = "skina-cosmos"
    kind         = "MongoDB" # Outras opções: GlobalDocumentDB (SQL) e Parse
    capabilities = [
      "DisableRateLimitingResponses",
      "EnableAggregationPipeline",
      "EnableServerless",
      "mongoEnableDocLevelTTL",
      "EnableMongo",
      "MongoDBv3.4",
      "EnableMongoRetryableWrites"
    ]
    # Definição dos bancos de dados e suas coleções
    databases = [
      {
        db_name     = "skina-db"
        collections = ["skina-data"]
      }
    ]
  }

  aks = {
    name     = "skina-k8s"
    sku_tier = "Free"
    default_node_pool = {
      name       = "default"
      node_count = 1
      vm_size    = "Standard_B2s"
    }
  }

  function = {
    name     = "skina-lanches-auth"
    tier     = "Dynamic"
    sku_name = "Y1"
  }

  tags = jsondecode(file("./tags.json"))
}