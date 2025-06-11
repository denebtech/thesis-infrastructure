output "bucket_name" {
  description = "The name of the S3 bucket used for Terraform state."
  value       = aws_s3_bucket.terraform_state.bucket
}

output "bucket_arn" {
  description = "The ARN of the S3 bucket used for Terraform state."
  value       = aws_s3_bucket.terraform_state.arn
}
