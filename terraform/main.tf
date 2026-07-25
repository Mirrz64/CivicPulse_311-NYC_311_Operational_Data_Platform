terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=4.1.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
  subscription_id = file("credentials.txt")
}

resource "azurerm_resource_group" "civic_pulse_resource" {
  name     = "civic-pulse-resource"
  location = "uksouth"
}

resource "azurerm_storage_account" "civic_pulse_storage" {
  name                     = "civicpulsestorage123"
  resource_group_name      = azurerm_resource_group.civic_pulse_resource.name
  location                 = azurerm_resource_group.civic_pulse_resource.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  tags = {
    environment = "staging"
  }
}

resource "azurerm_storage_container" "bronze" {
  name                  = "bronze"
  storage_account_name  = azurerm_storage_account.civic_pulse_storage.name
  container_access_type = "private"
  depends_on            = [azurerm_storage_account.civic_pulse_storage]
}

resource "azurerm_storage_container" "silver" {
  name                  = "silver"
  storage_account_name  = azurerm_storage_account.civic_pulse_storage.name
  container_access_type = "private"
  depends_on            = [azurerm_storage_account.civic_pulse_storage]
}

resource "azurerm_postgresql_flexible_server" "civicpulsedb_server" {
  name                          = "civicpulsepgserver"
  resource_group_name           = azurerm_resource_group.civic_pulse_resource.name
  location                      = azurerm_resource_group.civic_pulse_resource.location

  version                       = "16"
  public_network_access_enabled = true
  administrator_login           = var.username
  administrator_password        = var.pg_password
  zone                          = "1"

  storage_mb   = 32768
  storage_tier = "P30"

  sku_name   = "B_Standard_B1ms"

  authentication {
    password_auth_enabled = true
  }

  depends_on = [azurerm_resource_group.civic_pulse_resource]
}

# UPDATED: Flexible Server Database configuration
resource "azurerm_postgresql_flexible_server_database" "db_database" {
  name      = "civic_pulse_db"
  server_id = azurerm_postgresql_flexible_server.civicpulsedb_server.id
  charset   = "utf8"
  collation = "en_US.utf8"

  # prevent the possibility of accidental data loss
  lifecycle {
    prevent_destroy = false
  }
}

# Data Factory
data "azurerm_storage_account" "example" {
  name                = "civicpulsestorage123"
  resource_group_name = azurerm_resource_group.civic_pulse_resource.name
}

resource "azurerm_data_factory" "data_factory_server" {
  name                = "civicpulseserver1"
  location            = azurerm_resource_group.civic_pulse_resource.location
  resource_group_name = azurerm_resource_group.civic_pulse_resource.name
}

resource "azurerm_data_factory_linked_service_azure_blob_storage" "blobstorage1" {
  name              = "pulseblobstorage1"
  data_factory_id   = azurerm_data_factory.data_factory_server.id
  connection_string = data.azurerm_storage_account.example.primary_connection_string
}

resource "azurerm_data_factory_dataset_parquet" "civicpulseds" {
  name                = "civic_pulse_parquet_ds"
  data_factory_id     = azurerm_data_factory.data_factory_server.id
  linked_service_name = azurerm_data_factory_linked_service_azure_blob_storage.blobstorage1.name

  compression_codec = "snappy"

  azure_blob_storage_location {
    container = "silver"
    filename = "urban_service_requests.parquet"
  }
}