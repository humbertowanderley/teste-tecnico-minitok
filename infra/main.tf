module "mongodb_atlas" {
  source = "./modules/mongodb_atlas"
  api_pub_key = var.mongodb_atlas_api_pub_key
  api_pri_key = var.mongodb_atlas_api_pri_key
  org_id = var.mongodb_atlas_org_id
  database_username = var.mongodb_atlas_database_username
  database_user_password = var.mongodb_atlas_database_user_password
  vm_ip_address = module.parse_server.parse_server_ip
}

module "parse_server" {
  source = "./modules/gcp_vm_parse_server"
  parse_master_key = var.parse_master_key
  parse_client_key = var.parse_client_key
  parse_app_id =  var.parse_app_id
  database_uri = module.mongodb_atlas.mongodb_uri
  gcp_project_id = var.gcp_project_id
  gcp_region = var.gcp_region_id
}

/*
module "gcp_bucket" {
  source = "./modules/gcp_bucket"
  project_id = var.gcp_project_id
  region = var.gcp_region_id
  bucket_name = "minitok_apk_storage"
}
*/
