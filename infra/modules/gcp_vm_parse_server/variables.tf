variable "parse_master_key" {
  description = "Parse master key"
  type        = string
}

variable "zone" { 
  default = "us-central1-a" 
}

variable "parse_app_id" {
  description = "App id"
  type        = string
}

variable "parse_client_key" {
  description = "Client key"
  type        = string
}

variable "database_uri" {
  description = "Database Uri"
  type        = string
}

variable "gcp_project_id" {
  description = "GCP project id"
  type        = string
}

variable "gcp_region" {
  description = "GCP region"
  type        = string
}
