terraform_binary = "terraform"

locals {
  project_name = "thesis-infra"
  common_tags = {
    "Project" = "ThesisInfrastructure"
    "Owner"   = "denebtech"
    "Team"    = "DevOps"
  }
}

remote_state {
  backend = "s3"

  generate = {
    path      = "backend.tf"
    if_exists = "overwrite"
  }

  config = {
    bucket = "thesis-infra-tf-state20250612222440593700000001"

    key          = "${path_relative_to_include()}/terraform.tfstate"
    region       = "us-east-2"
    encrypt      = true
    use_lockfile = true
  }
}
