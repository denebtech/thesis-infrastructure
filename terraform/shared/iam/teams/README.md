# IAM Teams Terraform Module

This Terraform module creates and manages AWS IAM groups (teams) with their associated memberships and policies. It provides a simple way to organize IAM users into teams with specific permissions.

## Features

- ✅ **IAM Group creation** - Creates IAM groups to represent teams
- ✅ **Group membership management** - Manages user membership in groups
- ✅ **Policy attachment** - Attaches custom policies to groups

## Usage

### Basic Usage

```hcl
module "teams" {
  source = "./terraform/shared/iam/teams"

  teams = {
    "developers" = {
      path    = "/teams/"
      members = ["john.doe", "jane.smith"]
      policy  = jsonencode({
        Version = "2012-10-17"
        Statement = [
          {
            Effect = "Allow"
            Action = [
              "s3:GetObject",
              "s3:PutObject"
            ]
            Resource = "arn:aws:s3:::dev-bucket/*"
          }
        ]
      })
    }
  }
}
```

### Multiple Teams with Different Policies

```hcl
module "company_teams" {
  source = "./terraform/shared/iam/teams"

  teams = {
    "developers" = {
      path    = "/teams/engineering/"
      members = ["dev1@company.com", "dev2@company.com"]
      policy  = file("${path.module}/policies/developers.json")
    }

    "researchers" = {
      path    = "/teams/research/"
      members = ["researcher1@company.com", "researcher2@company.com"]
      policy  = file("${path.module}/policies/researchers.json")
    }
  }
}
```

### Teams with External Policy Files

```hcl
module "teams_with_files" {
  source = "./terraform/shared/iam/teams"

  teams = {
    "data-scientists" = {
      path    = "/teams/data/"
      members = ["scientist1@company.com", "scientist2@company.com"]
      policy  = file("${path.module}/policies/data-scientists.json")
    }
  }
}
```

Example policy file (`policies/data-scientists.json`):

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:ListBucket",
        "s3:GetObject",
        "s3:PutObject"
      ],
      "Resource": [
        "arn:aws:s3:::data-lake-bucket",
        "arn:aws:s3:::data-lake-bucket/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "sagemaker:CreateNotebookInstance",
        "sagemaker:DescribeNotebookInstance"
      ],
      "Resource": "*"
    }
  ]
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
| [aws_iam_group.group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_group) | resource |
| [aws_iam_group_membership.membership](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_group_membership) | resource |
| [aws_iam_group_policy.group_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_group_policy) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_teams"></a> [teams](#input\_teams) | A map of team configurations where each key is the team name and value contains team settings | <pre>map(object({<br>  path    = optional(string, "/teams")<br>  members = optional(list(string), [])<br>  policy  = optional(string, "")<br>}))</pre> | n/a | yes |

### Input Details

#### `teams` Variable Structure

- **Key**: Team name (string) - This will be the IAM group name
- **Value**: Object with the following properties:
  - `path` (optional): The path for the IAM group. Defaults to `/teams`
  - `members` (optional): List of IAM user names to add to the group. Defaults to empty list
  - `policy` (optional): JSON policy document as a string. Defaults to empty string

## Outputs

This module does not expose any outputs. The created resources can be referenced using their resource addresses if needed.

## Resource Naming Convention

- **IAM Groups**: Uses the team name directly (e.g., `developers`, `researchers`)
- **Group Memberships**: Named as `{team_name}-membership`
- **Group Policies**: Named as `{team_name}-policy`

## Dependencies

The module includes proper resource dependencies:

- Group memberships depend on groups being created first
- Group policies depend on groups being created first

This ensures resources are created and destroyed in the correct order.

## Security Considerations

1. **Policy Validation**: Always validate IAM policies before applying
2. **Regular Audits**: Periodically review team memberships and permissions
3. **Least Privilege**: Grant only the minimum required permissions
4. **Separation of Duties**: Avoid giving excessive permissions to any single team

## Troubleshooting

### Common Issues

1. **User Not Found Error**: Ensure all users in the `members` list exist before creating teams
2. **Invalid Policy**: Validate JSON policy syntax before applying
3. **Path Restrictions**: IAM paths must start and end with `/`

### Example Error Resolution

If you get a "user not found" error, ensure users are created first:

```hcl
# Create users first
module "users" {
  source = "../users"
  users  = ["john.doe", "jane.smith"]
}

# Then create teams
module "teams" {
  source = "../teams"

  depends_on = [module.users]

  teams = {
    "developers" = {
      members = ["john.doe", "jane.smith"]
      # ... other configuration
    }
  }
}
```

## Contributing

This module is part of the [thesis-infrastructure](../../../README.md) project. Please follow the project's contribution guidelines and ensure all pre-commit hooks pass before submitting changes.

## License

This project is licensed under the MIT License - see the [LICENSE](../../../LICENSE) file for details.
