variable "bucket_name" {
  description = "The name of the S3 bucket to store Terraform state."
  type        = string
}

variable "force_destroy" {
  description = "Enable force destroy of the S3 bucket, allowing deletion even if it contains objects."
  type        = bool
  default     = false
}

variable "tags" {
  description = "A map of tags to assign to the S3 bucket."
  type        = map(string)
  default     = {}
}
