# tf-state-bucket

Terraform module to create an S3 bucket specifically designed for storing Terraform state files with best practices for security, versioning, lifecycle management, and compliance.

## Features

- **S3 bucket for Terraform state storage** with configurable naming prefix
- **Versioning enabled** for state file history and rollback capabilities
- **Object Lock enabled** for additional protection against accidental deletion or modification, granting immutability
- **Server-side encryption** with AWS KMS using S3 managed keys
- **Public access blocked** for enhanced security
- **Private ACL** to prevent unauthorized access
- **Lifecycle management** with intelligent tiering and cleanup policies
- **Compliance checks** with Checkov security scanning rules
- **Force destroy option** for development environments

## Usage

### Basic Usage

```hcl
module "tf_state_bucket" {
  source = "./terraform/shared/storage/tf-state-bucket"

  bucket_name = "my-terraform-state"

  tags = {
    Project     = "thesis-infrastructure"
    Environment = "production"
    Purpose     = "terraform-state"
  }
}
```

### Development Environment

```hcl
module "tf_state_bucket_dev" {
  source = "./terraform/shared/storage/tf-state-bucket"

  bucket_name   = "my-terraform-state-dev"
  force_destroy = true  # Allows easy cleanup in dev environments

  tags = {
    Project     = "thesis-infrastructure"
    Environment = "development"
    Purpose     = "terraform-state"
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
| [aws_s3_bucket.terraform_state](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_versioning.terraform_state](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.terraform_state](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_acl.terraform_state](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_acl) | resource |
| [aws_s3_bucket_public_access_block.terraform_state](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_lifecycle_configuration.terraform_state](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_lifecycle_configuration) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | The name of the S3 bucket to store Terraform state. | `string` | n/a | yes |
| <a name="input_force_destroy"></a> [force\_destroy](#input\_force\_destroy) | Enable force destroy of the S3 bucket, allowing deletion even if it contains objects. | `bool` | `false` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to assign to the S3 bucket. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bucket_name"></a> [bucket\_name](#output\_bucket\_name) | The name of the S3 bucket used for Terraform state. |
| <a name="output_bucket_arn"></a> [bucket\_arn](#output\_bucket\_arn) | The ARN of the S3 bucket used for Terraform state. |

## Security Features

This module implements comprehensive security best practices:

### Encryption

- **Server-side encryption** enabled with AWS KMS
- Uses AWS S3 managed encryption keys (`aws:s3`)

### Versioning

- **Versioning enabled** to maintain history of state files
- Protects against accidental state corruption or deletion

### Object Lock

- **Object Lock enabled** for Write-Once-Read-Many (WORM) protection
- Prevents objects and their versions from being deleted or overwritten
- Provides additional layer of protection for critical Terraform state files
- Complements versioning by ensuring immutability of stored state versions

### Lifecycle Management

- **Intelligent tiering** to optimize storage costs:
  - Objects transition to Standard-IA after 30 days
  - Objects transition to Glacier after 60 days
  - Non-current versions expire after 120 days
- **Incomplete multipart upload cleanup** after 7 days

## Compliance

This module includes Checkov security compliance checks with appropriate skips for non-applicable rules:

- `CKV_AWS_18`: Bucket access logging skipped (not required for state buckets)
- `CKV2_AWS_62`: Bucket event notifications skipped (not required)
- `CKV_AWS_144`: Cross-region replication skipped (not required)

## Best Practices

1. **Unique naming**: The module uses `bucket_prefix` to ensure unique bucket names
2. **Tagging**: Always include relevant tags for resource management
4. **Force destroy**: Only enable in development environments for easy cleanup
5. **Object Lock**: Provides immutable storage for critical state files, preventing accidental deletion
6. **State file protection**: The combination of versioning and object lock ensures comprehensive protection

## Contributing

This module is part of the [thesis-infrastructure](../../../README.md) project. Please follow the project's contribution guidelines and ensure all pre-commit hooks pass before submitting changes.

## License

This project is licensed under the MIT License - see the [LICENSE](../../../LICENSE) file for details.
