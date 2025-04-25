variable "project_id" {
  description = "ID do projeto no GCP"
  type        = string
}

variable "region" {
  description = "Região do bucket"
  type        = string
  default     = "us-central1"
}

variable "bucket_name" {
  description = "Nome do bucket"
  type        = string
}
