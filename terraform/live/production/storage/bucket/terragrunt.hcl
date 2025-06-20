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

  enable_notifications = true
  notification_topics = {
    "profiling-report" = {
      id            = "profiling-report-notification"
      events        = ["s3:ObjectCreated:*"]
      filter_prefix = "profiling-report/"
    }
  }
  notification_subscriptions = {
    "email" = {
      protocol = "email"
      endpoint = "jairo@denebtech.com.ar"
    }
  }

  tags = merge(
    include.root.locals.common_tags,
    {
      Environment = "production"
    }
  )
}
