data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

module "secure_s3" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "3.15.1"

  create_bucket = var.s3.create_bucket

  attach_elb_log_delivery_policy    = var.s3.attach_elb_log_delivery_policy
  attach_lb_log_delivery_policy     = var.s3.attach_lb_log_delivery_policy
  attach_access_log_delivery_policy = var.s3.attach_access_log_delivery_policy
  # [S3.5] S3 buckets should require requests to use Secure Socket Layer
  # https://docs.aws.amazon.com/securityhub/latest/userguide/s3-controls.html#s3-5
  attach_deny_insecure_transport_policy    = true
  attach_require_latest_tls_policy         = var.s3.attach_require_latest_tls_policy
  policy                                   = var.s3.policy
  attach_policy                            = var.s3.attach_policy
  attach_public_policy                     = var.s3.attach_public_policy
  attach_inventory_destination_policy      = var.s3.attach_inventory_destination_policy
  attach_analytics_destination_policy      = var.s3.attach_analytics_destination_policy
  attach_deny_incorrect_encryption_headers = var.s3.attach_deny_incorrect_encryption_headers
  attach_deny_incorrect_kms_key_sse        = var.s3.attach_deny_incorrect_kms_key_sse
  acl                                      = var.s3.acl

  allowed_kms_key_arn                    = var.s3.allowed_kms_key_arn
  attach_deny_unencrypted_object_uploads = var.s3.attach_deny_unencrypted_object_uploads

  bucket        = var.s3.bucket
  bucket_prefix = var.s3.bucket_prefix

  acceleration_status = var.s3.acceleration_status
  request_payer       = var.s3.request_payer
  website             = var.s3.website

  cors_rule = var.s3.cors_rule
  # [S3.14] S3 general purpose buckets should have versioning enabled
  # https://docs.aws.amazon.com/securityhub/latest/userguide/s3-controls.html#s3-14
  versioning                           = true
  logging                              = var.s3.logging
  lifecycle_rule                       = concat(var.s3.lifecycle_rule, [for k, v in local.s3_lifecycle_rules : v if contains(var.s3.default_lifecycle_rules, k)])
  replication_configuration            = var.s3.replication_configuration
  server_side_encryption_configuration = var.s3.server_side_encryption_configuration
  intelligent_tiering                  = var.s3.intelligent_tiering
  object_lock_configuration            = var.s3.object_lock_configuration
  metric_configuration                 = var.s3.metric_configuration
  inventory_configuration              = var.s3.inventory_configuration

  access_log_delivery_policy_source_buckets  = var.s3.access_log_delivery_policy_source_buckets
  access_log_delivery_policy_source_accounts = var.s3.access_log_delivery_policy_source_accounts

  grant                 = var.s3.grant
  owner                 = var.s3.owner
  expected_bucket_owner = var.s3.expected_bucket_owner

  inventory_source_account_id       = var.s3.inventory_source_account_id
  inventory_source_bucket_arn       = var.s3.inventory_source_bucket_arn
  inventory_self_source_destination = var.s3.inventory_self_source_destination

  # ---
  # [S3.2] S3 general purpose buckets should block public read access
  # https://docs.aws.amazon.com/securityhub/latest/userguide/s3-controls.html#s3-2
  # [S3.3] S3 general purpose buckets should block public write access
  # https://docs.aws.amazon.com/securityhub/latest/userguide/s3-controls.html#s3-3
  # [S3.8] S3 general purpose buckets should block public access
  # https://docs.aws.amazon.com/securityhub/latest/userguide/s3-controls.html#s3-8
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
  # ---

  analytics_configuration           = var.s3.analytics_configuration
  analytics_source_account_id       = var.s3.analytics_source_account_id
  analytics_source_bucket_arn       = var.s3.analytics_source_bucket_arn
  analytics_self_source_destination = var.s3.analytics_self_source_destination

  control_object_ownership = var.s3.control_object_ownership
  object_ownership         = var.s3.object_ownership
  object_lock_enabled      = var.s3.object_lock_enabled
  force_destroy            = var.s3.force_destroy
  tags                     = var.s3.tags
}

module "s3_notification" {
  source  = "terraform-aws-modules/s3-bucket/aws//modules/notification"
  version = "3.15.1"

  bucket = module.secure_s3.s3_bucket_id

  create            = var.s3_notification.create
  create_sns_policy = var.s3_notification.create_sns_policy
  create_sqs_policy = var.s3_notification.create_sqs_policy

  eventbridge          = var.s3_notification.eventbridge
  lambda_notifications = var.s3_notification.lambda_notifications
  sqs_notifications    = var.s3_notification.sqs_notifications
  sns_notifications    = var.s3_notification.sns_notifications
}
