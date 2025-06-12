generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite"

  contents = <<EOF
    provider "aws" {
      region = "us-east-2"
    }
    EOF
}
