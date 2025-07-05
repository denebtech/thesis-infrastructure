terraform {
  source = "../../../../shared/registry"
}

include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite"

  contents = <<EOF
    provider "alicloud" {
      region = "us-east-1"
    }
  EOF
}

inputs = {
  registry = {
    namespace = "denebtech_public_c645d3q2"
    repos = {
      "thesis-api" = {
        summary   = "Thesis API Repository"
        repo_type = "PRIVATE"
        detail    = "This repository contains the source code for the Thesis API, which provides endpoints for managing thesis-related data and operations."
      }
      "thesis-frontend" = {
        summary   = "Thesis Frontend Repository"
        repo_type = "PRIVATE"
        detail    = "This repository contains the source code for the Thesis Frontend, which is the user interface for interacting with the Thesis API."
      }
    }
  }
}
