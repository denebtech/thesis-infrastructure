terraform {
  source = "../../../../shared/iam/users"
}

include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

include "global" {
  path = find_in_parent_folders("global.hcl")
}

inputs = {
  users = [
    "pablo.ramos@thesis.io",
    "app@thesis.io",
  ]
  path = "/users/"
  tags = include.root.locals.common_tags
}
