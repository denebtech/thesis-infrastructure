variable "users" {
  type        = list(string)
  description = "List of IAM user names to create."
}

variable "path" {
  type        = string
  default     = "/users/"
  description = "The path for the IAM users."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "A map of tags to assign to the IAM users."
}
