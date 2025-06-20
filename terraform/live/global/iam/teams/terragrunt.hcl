terraform {
  source = "../../../../shared/iam/teams"
}

include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

include "global" {
  path = find_in_parent_folders("global.hcl")
}

dependency "users" {
  config_path  = "../users"
  skip_outputs = true
}

inputs = {
  teams = {
    "researchers" = {
      path    = "/researchers/"
      members = ["pablo.ramos@thesis.io"]
      policy  = file("${get_terragrunt_dir()}/researchers.json")
    }
  }
}
