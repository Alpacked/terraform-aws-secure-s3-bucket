output "s3" {
  description = "Get all outputs from the S3 public module. Check https://github.com/terraform-aws-modules/terraform-aws-s3-bucket/tree/v3.15.1#outputs for possible outputs."
  value       = module.secure_s3
}

output "s3_notification" {
  description = "Get all outputs from the S3 Notification public module. Check https://github.com/terraform-aws-modules/terraform-aws-s3-bucket/tree/v3.15.1/modules/notification#outputs for possible outputs."
  value       = module.s3_notification
}