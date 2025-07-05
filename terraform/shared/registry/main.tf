resource "alicloud_cr_repo" "main" {
  for_each = var.registry.repos

  namespace = var.registry.namespace
  name      = each.key
  summary   = each.value.summary
  repo_type = each.value.repo_type
  detail    = each.value.detail
}
