resource "azurerm_resource_group" "rg" {
  location = var.resource_group_location
  name     = "${random_pet.prefix.id}-rg"
}

resource "random_pet" "prefix" {
  prefix = var.prefix
  length = 1
}

resource "azurerm_subnet" rg {
  name                 = "rg-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = "${var.virtual_network_name}"
  address_prefixes     = var.netapp_address_spaces

  delegation {
    name = "netapp"

    service_delegation {
      name    = "Microsoft.Netapp/volumes"
      actions = ["Microsoft.Network/networkinterfaces/*", "Microsoft.Network/virtualNetworks/subnets/join/action"]
    }
  }
}

resource "azurerm_netapp_account" rg {
  name                = "rg-netappaccount"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_netapp_pool" rg {
  name                = "rg-netapppool"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  account_name        = azurerm_netapp_account.rg.name
  service_level       = "Premium"
  size_in_tb          = 2
}

resource "azurerm_netapp_volume" rg {
  name                       = "rg-netappvolume"
  location                   = azurerm_resource_group.rg.location
  zone                       = "1"
  resource_group_name        = azurerm_resource_group.rg.name
  account_name               = azurerm_netapp_account.rg.name
  pool_name                  = azurerm_netapp_pool.rg.name
  volume_path                = "my-unique-file-path"
  service_level              = "Premium"
  subnet_id                  = azurerm_subnet.rg.id
  network_features           = "Basic"
  protocols                  = ["CIFS"]
  security_style             = "ntfs"
  storage_quota_in_gb        = 100
  snapshot_directory_visible = false

  # When creating volume from a snapshot
  create_from_snapshot_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/group1/providers/Microsoft.NetApp/netAppAccounts/account1/capacityPools/pool1/volumes/volume1/snapshots/snapshot1"

  # Following section is only required if deploying a data protection volume (secondary)
  # to enable Cross-Region Replication feature
  data_protection_replication {
    endpoint_type             = "dst"
    remote_volume_location    = azurerm_resource_group.rg.location
    remote_volume_resource_id = azurerm_netapp_volume.rg.id
    replication_frequency     = "10minutes"
  }

  # Enabling Snapshot Policy for the volume
  # Note: this cannot be used in conjunction with data_protection_replication when endpoint_type is dst
  data_protection_snapshot_policy {
    snapshot_policy_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/group1/providers/Microsoft.NetApp/netAppAccounts/account1/snapshotPolicies/snapshotpolicy1"
  }

  # prevent the possibility of accidental data loss
  lifecycle {
    prevent_destroy = true
  }
}