variable "cortex_api_key" {
  description = "Cortex API key. Pass via TF_VAR_cortex_api_key environment variable."
  type        = string
  sensitive   = true
}

variable "cortex_base_url" {
  description = "Cortex API base URL."
  type        = string
  default     = "https://api.getcortexapp.com"
}
