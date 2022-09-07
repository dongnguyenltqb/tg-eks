include "dev" {
  path = find_in_parent_folders("dev.hcl")
}

include "root" {
  path = "${dirname("../../")}/terragrunt.hcl"
}

terraform {
  source = "../../../components//vpc-eks"
}

dependency "jump-server-role" {
  config_path = "${get_terragrunt_dir()}/../jump-server-role"
  mock_outputs = {
    profile_name = "name"
  }
}


inputs = {
  cluster_name                  = "cafe"
  jump_server_profile_role_name = dependency.jump-server-role.outputs.profile_name
  jump_pubkey                   = <<EOF
ssh pub key
EOF

  tags = {
    Project   = "Cafe"
    Component = "VPC-EKS"
  }
}