output "repo_ids" {
  value = {
    for repo in alicloud_cr_repo.main :
    repo.name => repo.id
  }
}
