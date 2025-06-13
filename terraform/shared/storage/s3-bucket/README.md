# S3 Bucket Terraform Module

This Terraform module creates a secure and configurable AWS S3 bucket with best practices enabled by default.

## Features

- ✅ **Versioning enabled** - Automatically enables versioning for data protection
- ✅ **Server-side encryption** - Uses AWS KMS encryption with S3 managed keys
- ✅ **Public access blocked** - Blocks all public access by default for security
- ✅ **Lifecycle management** - Automatically expires old versions after 120 days
- ✅ **SNS notifications** - Optional S3 event notifications via SNS
- ✅ **Tagging support** - Flexible tagging with automatic management tags

## Usage

### Basic Usage

```hcl
module "my_bucket" {
  source = "./terraform/shared/storage/s3-bucket"

  bucket_name = "my-app-storage"
  environment = "production"

  tags = {
    Project = "MyApplication"
    Owner   = "DataTeam"
  }
}
```

### With SNS Notifications

```hcl
module "my_bucket_with_notifications" {
  source = "./terraform/shared/storage/s3-bucket"

  bucket_name          = "my-app-storage"
  environment          = "production"
  enable_notifications = true

  notification_topics = {
    object_created = {
      events        = ["s3:ObjectCreated:*"]
      filter_prefix = "uploads/"
      filter_suffix = ".jpg"
    }
    object_removed = {
      id     = "object-deletion-notification"
      events = ["s3:ObjectRemoved:*"]
    }
  }

  tags = {
    Project = "MyApplication"
    Owner   = "DataTeam"
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0.0 |
| aws | ~> 5.90.0 |

## Providers

| Name | Version |
|------|---------|
| aws | ~> 5.90.0 |

## Resources

| Name | Type |
|------|------|
| [aws_s3_bucket.bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_versioning.bucket_versioning](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |
| [aws_s3_bucket_policy.bucket_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_lifecycle_configuration.bucket_lifecycle](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_lifecycle_configuration) | resource |
| [aws_s3_bucket_public_access_block.bucket_public_access_block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.bucket_encryption](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_sns_topic.bucket_notifications](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic) | resource |
| [aws_s3_bucket_notification.bucket_notification](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_notification) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| bucket_name | The name of the S3 bucket to create. | `string` | n/a | yes |
| environment | The environment for which the S3 bucket is being created (e.g., dev, staging, production). | `string` | n/a | yes |
| tags | A map of tags to assign to the S3 bucket. | `map(string)` | `{}` | no |
| enable_notifications | Whether to enable S3 bucket notifications. | `bool` | `false` | no |
| notification_topics | A list of notification topics to configure for the S3 bucket. | <pre>map(object({<br>  id            = optional(string, "")<br>  events        = list(string)<br>  filter_prefix = optional(string, null)<br>  filter_suffix = optional(string, null)<br>}))</pre> | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| bucket_name | The name of the S3 bucket created. |
| bucket_arn | The ARN of the S3 bucket created. |

## Security Considerations

This module implements several security best practices:

1. **Public Access Blocked**: All public access is blocked by default
2. **Encryption**: Server-side encryption is enabled using AWS KMS
3. **Bucket Policy**: Restrictive bucket policy allowing only specific actions
4. **Versioning**: Object versioning is enabled for data protection

## Lifecycle Management

The module automatically configures lifecycle rules to:
- Expire non-current object versions after 120 days
- This helps manage storage costs by cleaning up old versions

## License

This module is part of the thesis infrastructure project.
