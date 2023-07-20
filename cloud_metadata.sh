provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "example-resource-group"
  location = "East US"
}

resource "azurerm_app_service_plan" "example" {
  name                = "example-appserviceplan"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "azurerm_app_service" "example" {
  name                = "example-webapp"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  app_service_plan_id = azurerm_app_service_plan.example.id
}

resource "azurerm_virtual_machine" "example" {
  name                  = "example-vm"
  location              = azurerm_resource_group.example.location
  resource_group_name   = azurerm_resource_group.example.name
  network_interface_ids = [azurerm_network_interface.example.id]
  vm_size               = "Standard_DS1_v2"

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  os_profile {
    computer_name  = "hostname"
    admin_username = "adminuser"
    admin_password = "Password1234!"
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}

resource "azurerm_network_interface" "example" {
  name                = "example-nic"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_sql_server" "example" {
  name                         = "example-sqlserver"
  resource_group_name          = azurerm_resource_group.example.name
  location                     = azurerm_resource_group.example.location
  version                      = "12.0"
  administrator_login          = "sqladmin"
  administrator_login_password = "Password1234!"
}

resource "azurerm_sql_database" "example" {
  name                = "example-sqldb"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  server_name         = azurerm_sql_server.example.name
  requested_service_objective_name = "S0"
}



terraform init
terraform apply


---------------------------------------------

#!/bin/bash

metadata_url="http://169.254.169.254/latest/meta-data/"

cloud_metadata() {
  local metadata=$(curl -s "$metadata_url")
  local json="{"

  while IFS='=' read -r key value; do
    local trimmed_key="${key%%[[:space:]]}"
    local trimmed_value="${value%%[[:space:]]}"
    json+="\"$trimmed_key\": \"$trimmed_value\","
  done <<< "$metadata"

  json="${json%,}"
  json+="}"

  echo "$json"
}

instance_metadata=$(cloud_metadata)
echo "$instance_metadata"

--------------------------------------------------
import java.util.HashMap;
import java.util.Map;

public class NestedObject {

    public static Object getValueByKey(Map<String, Object> obj, String key) {
        String[] keys = key.split("/");
        Map<String, Object> currentObj = obj;

        for (String k : keys) {
            if (currentObj.containsKey(k)) {
                Object value = currentObj.get(k);
                if (value instanceof Map) {
                    currentObj = (Map<String, Object>) value;
                } else {
                    return value;
                }
            } else {
                return null;
            }
        }

        return null;
    }

    public static void main(String[] args) {
        Map<String, Object> object1 = new HashMap<>();
        object1.put("a", new HashMap<>());
        ((Map<String, Object>) object1.get("a")).put("b", new HashMap<>());
        ((Map<String, Object>) ((Map<String, Object>) object1.get("a")).get("b")).put("c", "d");

        String key1 = "a/b/c";
        Object value1 = getValueByKey(object1, key1);
        System.out.println("Value: " + value1); // Output: Value: d

        Map<String, Object> object2 = new HashMap<>();
        object2.put("x", new HashMap<>());
        ((Map<String, Object>) object2.get("x")).put("y", new HashMap<>());
        ((Map<String, Object>) ((Map<String, Object>) object2.get("x")).get("y")).put("z", "a");

        String key2 = "x/y/z";
        Object value2 = getValueByKey(object2, key2);
        System.out.println("Value: " + value2); // Output: Value: a
    }
}
