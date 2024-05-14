terraform {
  required_providers {
    panos = {
      source = "PaloAltoNetworks/panos"
      version = "1.11.1"
    }
  }
}

provider "panos" {
  hostname = var.panos_hostname
  username = var.panos_username
  password = var.panos_password
}

resource "panos_address_object" "example" {
    name = "localnet"
    value = "192.168.80.0/24"
    description = "The 192.168.80 network"

    lifecycle {
        create_before_destroy = true
    }
}

resource "panos_panorama_security_policy" "example" {
    device_group = "cngfw-az-DemoGroup"
    rulebase = "post-rulebase"
    rule {
        name = "the opposite of secure"
        audit_comment = "Initial config"
        source_zones = ["any"]
        source_addresses = [panos_address_object.example.value]
        source_users = ["any"]
        destination_zones = ["any"]
        destination_addresses = ["any"]
        applications = ["any"]
        services = ["application-default"]
        categories = ["any"]
        action = "allow"
    }

    lifecycle {
        create_before_destroy = true
    }
}