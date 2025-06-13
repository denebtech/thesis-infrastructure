# S3 Bucket Terraform Module

This Terraform module creates a secure and configurable AWS S3 bucket with best practices enabled by default.

## Features

- ✅ **Versioning enabled** - Automatically enables versioning for data protection
- ✅ **Server-side encryption** - Uses AWS KMS encryption with S3 managed keys
- ✅ **Public access blocked** - Blocks all public access by default for security
- ✅ **Lifecycle management** - Automatically expires old versions after 120 days
- ✅ **SNS notifications** - Optional S3 event notifications via SNS
- ✅ **Bucket policy** - Configurable bucket policy for access control
- ✅ **Tagging support** - Flexible tagging with automatic management tags
- ✅ **Compliance checks** - Includes Checkov security scanning rule skips

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
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.90.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.90.0 |

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
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | The name of the S3 bucket to create. | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment for which the S3 bucket is being created (e.g., dev, staging, production). | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to assign to the S3 bucket. | `map(string)` | `{}` | no |
| <a name="input_enable_notifications"></a> [enable\_notifications](#input\_enable\_notifications) | Whether to enable S3 bucket notifications. | `bool` | `false` | no |
| <a name="input_notification_topics"></a> [notification\_topics](#input\_notification\_topics) | A map of notification topics to configure for the S3 bucket. | <pre>map(object({<br>  id            = optional(string, "")<br>  events        = list(string)<br>  filter_prefix = optional(string, "")<br>  filter_suffix = optional(string, "")<br>}))</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bucket_name"></a> [bucket\_name](#output\_bucket\_name) | The name of the S3 bucket created. |
| <a name="output_bucket_arn"></a> [bucket\_arn](#output\_bucket\_arn) | The ARN of the S3 bucket created. |

## Security Features

This module implements comprehensive security best practices:

### Encryption

- **Server-side encryption** enabled with AWS KMS
- Uses AWS S3 managed encryption keys for KMS encryption

### Versioning

- **Versioning enabled** to maintain history of objects
- Protects against accidental data corruption or deletion

### Public Access Protection

- **Complete public access blocking** enabled:

  - Block public ACLs
  - Block public bucket policies
  - Ignore public ACLs
  - Restrict public buckets

### Bucket Policy

- **Configurable bucket policy** that allows:

  - `s3:GetObject` - Read access to objects
  - `s3:PutObject` - Write access to objects
  - `s3:DeleteObject` - Delete access to objects

- Policy is applied to all objects in the bucket (`/*`)

### Lifecycle Management

- **Automatic cleanup** of non-current object versions:
  - Non-current versions expire after 120 days
- **Incomplete multipart upload cleanup** after 7 days
- Helps manage storage costs by cleaning up old data

## Compliance

This module includes Checkov security compliance checks with appropriate skips for non-applicable rules:

- `CKV_AWS_18`: Bucket access logging skipped (not required for general-purpose buckets)
- `CKV_AWS_144`: Cross-region replication skipped (not required)

## Best Practices

1. **Unique naming**: The module uses `bucket_prefix` to ensure unique bucket names (AWS appends a unique suffix)
2. **Environment tagging**: Always specify the environment for proper resource management
3. **Lifecycle management**: Automatic cleanup of old versions helps control storage costs
4. **Security defaults**: All security features are enabled by default
5. **Notification filtering**: Use prefix/suffix filters to avoid unnecessary notifications

## Important Notes

- The `bucket_name` variable is used as a prefix. AWS will automatically append a unique suffix to ensure global uniqueness
- SNS notifications require `enable_notifications = true` and at least one entry in `notification_topics`
- The module automatically adds `ManagedBy = "Terraform"` and `Environment = {var.environment}` tags
- Bucket policy allows basic read/write/delete operations - modify as needed for specific use cases

## Contributing

This module is part of the [thesis-infrastructure](../../../README.md) project. Please follow the project's contribution guidelines and ensure all pre-commit hooks pass before submitting changes.

## License

This project is licensed under the MIT License - see the [LICENSE](../../../LICENSE) file for details.
