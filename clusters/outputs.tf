output "elasticsearch_dashboards_url" {
  value = var.enable_elasticsearch ? "http://${module.es-proxy[0].public_ip}" : null
}

output "elasticsearch_domain_name" {
  value = var.enable_elasticsearch ? module.elasticsearch[0].domain_hostname : null
}