#
# Configure the MongoDB Atlas Provider
#

terraform {
  required_providers {
    mongodbatlas = {
      source = "mongodb/mongodbatlas"
    }
  }
 }

provider "mongodbatlas" {
  public_key  = var.api_pub_key
  private_key = var.api_pri_key
}

#
# Create a Project
#
resource "mongodbatlas_project" "minitok_project" {
  name   = "minitokChallenge"
  org_id = var.org_id
}

resource "mongodbatlas_project_ip_access_list" "allow_vm_ip" {
  project_id = mongodbatlas_project.minitok_project.id
  ip_address = var.vm_ip_address
  comment    = "GCP VM Public IP"
}

#
# Create a Cluster
#
resource "mongodbatlas_cluster" "minitok_cluster" {
  project_id              = mongodbatlas_project.minitok_project.id
  name                    = "minitok"

  provider_name = "TENANT"
  backing_provider_name = "GCP"
  provider_region_name = "CENTRAL_US"

  provider_instance_size_name = "M0"
  auto_scaling_disk_gb_enabled = "false"
}

#
# Create an Atlas Admin Database User
#
resource "mongodbatlas_database_user" "minitok_user" {
  username           = var.database_username
  password           = var.database_user_password
  project_id         = mongodbatlas_project.minitok_project.id
  auth_database_name = "admin"

  roles {
    role_name     = "atlasAdmin"
    database_name = "admin"
  }
}
