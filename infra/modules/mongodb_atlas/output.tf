output "mongodb_uri" {
 value = format(
    "\"mongodb+srv://%s:%s@%s/?retryWrites=true&w=majority\"",
    var.database_username,
    var.database_user_password,
    replace(mongodbatlas_cluster.minitok_cluster.connection_strings.0.standard_srv, "mongodb+srv://", ""),
  )
  description = "URI de conexão do MongoDB Atlas"
}

output "minitok_project_id" {
 value = mongodbatlas_project.minitok_project.id
  description = "URI de conexão do MongoDB Atlas"
}
