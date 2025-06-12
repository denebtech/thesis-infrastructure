terraform {
  source = "../../../../shared/storage/tf-state-bucket"
}

include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

include "global" {
  path = find_in_parent_folders("global.hcl")
}

inputs = {
  bucket_name = "${include.root.locals.project_name}-tf-state"
  tags        = include.root.locals.common_tags
}
