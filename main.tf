terraform {
  required_providers {
    cortex = {
      source  = "cortexapps/cortex"
      version = "~> 0.1"
    }
  }
}

provider "cortex" {
  token         = var.cortex_api_key
  base_api_url  = var.cortex_base_url
}
