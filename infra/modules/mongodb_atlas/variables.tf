variable "api_pub_key" {
  description = "Atlas pub key"
  type        = string
}

variable "api_pri_key" {
  description = "Atlas pri key"
  type        = string
}

variable "org_id" {
  description = "Atlas org id"
  type        = string
}

variable "database_username" {
  description = "Atlas database username"
  type        = string
}

variable "database_user_password" {
  description = "Atlas database password"
  type        = string
}

variable "vm_ip_address" {
  description = "Static IP from the VM module"
  type        = string
}
