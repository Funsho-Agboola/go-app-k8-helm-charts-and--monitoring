output "cluster_name" {
  value = civo_kubernetes_cluster.my_cluster.name
}

output "applications" {
  value = civo_kubernetes_cluster.my_cluster.applications
}

output "kubernetes_version" {
  value = civo_kubernetes_cluster.my_cluster.kubernetes_version
}

output "api_endpoint" {
  value = civo_kubernetes_cluster.my_cluster.api_endpoint
}

output "dns_entry" {
  value = civo_kubernetes_cluster.my_cluster.dns_entry
}