provider "google" {
  project = var.project_id
  region  = var.region
}


resource "google_storage_bucket" "public_apk_bucket" {
  name          = var.bucket_name
  location      = var.region
  force_destroy = true  # Cuidado: permite deletar bucket com arquivos

  uniform_bucket_level_access = true
}

resource "google_storage_bucket_iam_member" "public_access" {
  bucket = google_storage_bucket.public_apk_bucket.name
  role   = "roles/storage.objectViewer"
  member = "allUsers"
}
