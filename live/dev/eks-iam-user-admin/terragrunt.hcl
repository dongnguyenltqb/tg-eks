include "dev" {
  path = find_in_parent_folders("dev.hcl")
}

include "root" {
  path = "${dirname("../../")}/terragrunt.hcl"
}

terraform {
  source = "../../../components//eks-iam-user-admin"
}

inputs = {
  name                = "cafeAdmin"
  managed_policy_arns = []
  custom_policy_documents = [
    jsonencode({
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Action" : [
            "eks:DescribeCluster"
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
    Component = "VPC-EKS"
  }
}