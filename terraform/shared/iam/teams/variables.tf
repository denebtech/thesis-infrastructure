variable "teams" {
  type = map(object({
    path    = optional(string, "/teams")
    members = optional(list(string), [])
    policy  = optional(string, "")
  }))
}
