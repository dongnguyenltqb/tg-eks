include "dev" {
  path = find_in_parent_folders("dev.hcl")
}

include "dev" {
  path = find_in_parent_folders("eks.hcl")
}

include "root" {
  path = "${dirname("../../")}/terragrunt.hcl"
}

terraform {
  source = "../../../components//app-pg14"
}

dependency "vpc-eks" {
  config_path = "${get_terragrunt_dir()}/../vpc-eks"
  mock_outputs = {
    cluster_name     = "cluster_name"
    cluster_ca       = "cluster_ca"
    cluster_endpoint = "cluster_endpoint"
    cluster_oidc_url = "url"
    cluster_oidc_arn = "arn"
  }
}

inputs = {
  app_name         = "pg14"
  cluster_name     = dependency.vpc-eks.outputs.cluster_name
  cluster_ca       = base64decode(dependency.vpc-eks.outputs.cluster_ca)
  cluster_endpoint = dependency.vpc-eks.outputs.cluster_endpoint
  cluster_oidc_url = dependency.vpc-eks.outputs.cluster_oidc_url
  cluster_oidc_arn = dependency.vpc-eks.outputs.cluster_oidc_arn
  custom_policy_documents = [
    jsonencode({
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Action" : [
            "ec2:*"
          ],
          "Resource" : [
            "*"
          ]
        }
      ]
    })
  ]
  tags = {
    Project   = "Cafe"
    Component = "EKS-APP"
  }
}