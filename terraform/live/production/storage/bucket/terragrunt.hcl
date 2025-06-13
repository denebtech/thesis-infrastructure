terraform {
  source = "../../../../shared/storage/s3-bucket"
}

include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

include "production" {
  path = find_in_parent_folders("production.hcl")
}

inputs = {
  bucket_name = "datalake-production-bucket"
  environment = "production"

  tags = merge(
    include.root.locals.common_tags,
    {
      Environment = "production"
    }
  )
}
