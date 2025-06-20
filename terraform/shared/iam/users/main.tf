resource "aws_iam_user" "users" {
  for_each = toset(var.users)

  name = each.value
  path = var.path

  tags = merge(
    {
      "ManagedBy" = "Terraform"
    },
    var.tags
  )
}
