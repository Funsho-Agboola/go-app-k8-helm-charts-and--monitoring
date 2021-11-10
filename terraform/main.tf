# Specify required provider as maintained by civo
terraform {
  required_providers {
    civo = {
      source = "civo/civo"
      version = "1.0.3"
    }
    local = {
      source = "hashicorp/local"
      version = "2.1.0"
    }
  }
}

provider "local" {}

# Configure the Civo Provider
provider "civo" {
  token = var.civo_api_key
  region = var.civo_region
}

# Create a firewall
resource "civo_firewall" "firewall" {
    name = "${var.civo_cluster_name}-firewall"
}

resource "civo_firewall_rule" "http" {
  firewall_id = civo_firewall.firewall.id
  protocol    = "tcp"
  start_port  = "80"
  end_port    = "80"
  cidr        = ["0.0.0.0/0"]
  direction   = "ingress"
  label       = "http"
  depends_on  = [civo_firewall.firewall]
}

resource "civo_firewall_rule" "https" {
  firewall_id = civo_firewall.firewall.id
  protocol    = "tcp"
  start_port  = "443"
  end_port    = "443"
  cidr        = ["0.0.0.0/0"]
  direction   = "ingress"
  label       = "https"
  depends_on  = [civo_firewall_rule.http]
}

resource "civo_firewall_rule" "api_server" {
  firewall_id = civo_firewall.firewall.id
  protocol    = "tcp"
  start_port  = "6443"
  end_port    = "6443"
  cidr        = ["0.0.0.0/0"]
  direction   = "ingress"
  label       = "kubernetes-api-server"
  depends_on  = [civo_firewall_rule.https]
}

resource "civo_kubernetes_cluster" "my_cluster" {
    name              = var.civo_cluster_name
    region            = var.civo_region
    applications      = var.civo_cluster_applications
    num_target_nodes  = var.civo_cluster_nodes
    target_nodes_size = var.civo_nodes_size
    firewall_id = civo_firewall.firewall.id
}

# Create a cluster
resource "local_file" "kubeconfig" {
    content   = civo_kubernetes_cluster.my_cluster.kubeconfig
    filename  = "${path.module}/kubeconfig.civo"
}