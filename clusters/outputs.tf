output "elasticsearch_dashboards_url" {
  value = var.enable_elasticsearch ? "http://${module.es-proxy[0].public_ip}" : null
}