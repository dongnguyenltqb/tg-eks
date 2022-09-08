generate "provider-eks" {
  path      = "provider-eks.tf"
  if_exists = "skip"
  contents  = <<EOF
  provider "kubernetes" {
    host                   = var.cluster_endpoint
    cluster_ca_certificate = var.cluster_ca
    exec {
      api_version = "client.authentication.k8s.io/v1alpha1"
      args        = ["eks", "get-token", "--cluster-name", var.cluster_name]
      command     = "aws"
    }
  }
EOF
}

generate "provider-eks-var" {
  path      = "provider-eks-var.tf"
  if_exists = "skip"
  contents  = <<EOF
  variable "cluster_name" {
    type = string
  }

  variable "cluster_ca" {
    type = string
  }

  variable "cluster_endpoint" {
    type = string
  }
EOF
}