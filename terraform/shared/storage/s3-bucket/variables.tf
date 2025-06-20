variable "bucket_name" {
  description = "The name of the S3 bucket to create."
  type        = string
}

variable "environment" {
  description = "The environment for which the S3 bucket is being created (e.g., dev, staging, production)."
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to the S3 bucket."
  type        = map(string)
  default     = {}
}

variable "enable_notifications" {
  description = "Whether to enable S3 bucket notifications."
  type        = bool
  default     = false
}

variable "notification_topics" {
  description = "A list of notification topics to configure for the S3 bucket."
  type = map(object({
    id            = optional(string, "")
    events        = list(string)
    filter_prefix = optional(string, "")
    filter_suffix = optional(string, "")
  }))
  default = {}
}

variable "notification_subscriptions" {
  description = "A list of notification subscriptions for the S3 bucket."
  type = map(object({
    protocol = optional(string, "email")
    endpoint = string
  }))
  default = {}
}
