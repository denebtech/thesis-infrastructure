# thesis-infrastructure

Infrastructure as Code (IaC) repository for thesis project resources using Terraform and Terragrunt.

## Overview

This repository contains Terraform modules and configurations to provision and manage cloud infrastructure resources for the thesis project. The infrastructure is organized using a modular approach with reusable components for different environments.

## Project Structure

```
thesis-infrastructure/
├── README.md                # This file
├── pyproject.toml           # Python project configuration
├── .pre-commit-config.yaml  # Pre-commit hooks configuration
└── terraform/               # Terraform configurations
    ├── live/                # Environment-specific configurations
    └── shared/              # Reusable Terraform modules
```

## Prerequisites

Before using this infrastructure repository, ensure you have the following tools installed:

### Required Tools

- **Terraform** (>= 1.0): Infrastructure as Code tool
- **Terragrunt** (>= 0.68.8): Flexible orchestration tool that allows IaC to scale
- **Python** (>= 3.12): For tooling and automation
- **Poetry**: Python dependency management
- **Git**: Version control
- **AWS CLI**: For AWS provider authentication (if using AWS)

## Setup

### 1. Clone the Repository

```bash
git clone ssh://git@gitea.denebtech.com.ar:2222/jairoq/thesis-infrastructure.git
cd thesis-infrastructure
```

### 2. Install Python Dependencies

```bash
poetry install
```

### 3. Setup Pre-commit Hooks

```bash
poetry run pre-commit install
```

### 4. Configure Cloud Provider Authentication

Configure your cloud provider credentials (example for AWS):

```bash
aws configure
# or
export AWS_ACCESS_KEY_ID="your-access-key"
export AWS_SECRET_ACCESS_KEY="your-secret-key"
export AWS_DEFAULT_REGION="us-east-1"
```

## Development Workflow

### 1. Making Changes

1. Create a new branch for your changes
2. Make modifications to the Terraform modules or configurations
3. Run pre-commit hooks to ensure code quality:

   ```bash
   poetry run pre-commit run --all-files
   ```

### 2. Testing

1. Validate Terraform syntax:

   ```bash
   cd terraform/live
   terragrunt run-all init
   terragrunt run-all validate
   ```

2. Plan changes to review what will be modified:

   ```bash
   terragrunt run-all plan
   ```

### 3. Code Quality

This project uses pre-commit hooks to maintain code quality:

- **YAML validation**: Ensures YAML files are properly formatted
- **Trailing whitespace removal**: Cleans up unnecessary whitespace
- **End-of-file fixer**: Ensures files end with a newline
- **Gitleaks**: Scans for secrets and sensitive information
- **Terraform formatting**: Automatically formats Terraform code

## Security

- Never commit sensitive information (credentials, API keys, etc.)
- Use environment variables or secret management services
- The `.gitignore` file excludes common sensitive files
- Gitleaks pre-commit hook helps prevent accidental secret commits

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Author

**Jairo JM Quispe** - [jairo@denebtech.com.ar](mailto:jairo@denebtech.com.ar)

## Support

For questions or issues related to this infrastructure setup, please create an issue in the repository or contact the author.
