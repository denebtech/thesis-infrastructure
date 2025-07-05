variable "registry" {
  type = object({
    namespace = string
    repos = map(object({
      summary   = string
      repo_type = optional(string, "PRIVATE")
      detail    = string
    }))
  })
}
