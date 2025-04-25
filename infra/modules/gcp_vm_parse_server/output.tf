output "parse_server_ip" {
  description = "Static external IP address of the Parse Server VM"
  value       = google_compute_address.static_ip.address
}
