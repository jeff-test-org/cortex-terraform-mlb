terraform {
  required_providers {
    cortex = {
      source  = "cortexapps/cortex"
      version = "~> 0.1"
    }
  }
}

provider "cortex" {
  api_key  = var.cortex_api_key
  base_url = var.cortex_base_url
}
