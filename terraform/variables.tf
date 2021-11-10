variable "civo_api_key" {
  type        = string
  description = "Civo API key to authenticate"
}

variable "civo_cluster_name" {
  type        = string
  description = "Civo kubernetes cluster name"
  default     = "uss-ari2"
}

variable "civo_region" {
  type        = string
  description = "Civo region to use"
  default     = "NYC1"
}

variable "civo_cluster_applications" {
  type        = string
  description = "applications to deploy on kubernetes cluster"
  default     = "Traefik"
}

variable "civo_cluster_nodes" {
  type        = number
  description = "kubernetes nodes count"
  default     = 3
}

variable "civo_nodes_size" {
  type        = string
  description = "instance size to use for nodes"
  default     = "g3.k3s.medium"
}
