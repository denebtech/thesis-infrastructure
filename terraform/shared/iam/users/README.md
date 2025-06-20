# IAM Users Terraform Module

This Terraform module creates and manages AWS IAM users with best practices for security and organization. It provides a simple way to create multiple IAM users with consistent naming and tagging.

## Features

- ✅ **IAM User creation** - Creates IAM users with configurable paths
- ✅ **Consistent tagging** - Applies standardized tags for resource management
- ✅ **Flexible paths** - Configurable IAM paths for organizational structure
- ✅ **Bulk user creation** - Create multiple users with a single module call

## Usage

### Basic Usage

```hcl
module "users" {
  source = "./terraform/shared/iam/users"

  users = [
    "john.doe@company.com",
    "jane.smith@company.com"
  ]

  tags = {
    Project = "MyApplication"
    Team    = "Engineering"
  }
}
```

### Custom Path and Advanced Tagging

```hcl
module "company_users" {
  source = "./terraform/shared/iam/users"

  users = [
    "dev1@company.com",
    "dev2@company.com",
    "researcher1@company.com"
  ]

  path = "/company/employees/"

  tags = {
    Project     = "CompanyInfrastructure"
    Department  = "IT"
    Environment = "production"
    CostCenter  = "12345"
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
| [aws_iam_user.users](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_users"></a> [users](#input\_users) | List of IAM user names to create. | `list(string)` | n/a | yes |
| <a name="input_path"></a> [path](#input\_path) | The path for the IAM users. | `string` | `"/users/"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to assign to the IAM users. | `map(string)` | `{}` | no |

## Troubleshooting

### Common Issues

1. **User Already Exists**:

   - Error: `User with name {username} already exists`
   - Solution: Check if the user exists in AWS console or use `terraform import`

2. **Invalid Path**:

   - Error: `Invalid path specified`
   - Solution: Ensure path starts and ends with `/`

3. **Tag Limits**:

   - Error: `Too many tags`
   - Solution: AWS allows up to 50 tags per resource

### Importing Existing Users

If you need to import existing IAM users into Terraform management:

```bash
# Import existing user
terraform import 'module.users.aws_iam_user.users["existing-user"]' existing-user
```

## Contributing

This module is part of the [thesis-infrastructure](../../../README.md) project. Please follow the project's contribution guidelines and ensure all pre-commit hooks pass before submitting changes.

## License

This project is licensed under the MIT License - see the [LICENSE](../../../LICENSE) file for details.
