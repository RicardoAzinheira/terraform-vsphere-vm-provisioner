terraform {
  required_providers {
    vsphere  = {
      version = "~> 2.6.1"
      source = "hashicorp/vsphere"
    }
    vault = {
      version = "3.25.0"
      source = "hashicorp/vault"
    }
  }
}

