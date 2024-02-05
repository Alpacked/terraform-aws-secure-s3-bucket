variable "s3" {
  description = "Configuration block for S3 with secure defaults. Check description of inputs on https://github.com/terraform-aws-modules/terraform-aws-s3-bucket/tree/v3.15.1#inputs website."
  type = object({
    create_bucket = optional(bool, true)

    attach_elb_log_delivery_policy    = optional(bool, false)
    attach_lb_log_delivery_policy     = optional(bool, false)
    attach_access_log_delivery_policy = optional(bool, false)

    # [S3.5] S3 buckets should require requests to use Secure Socket Layer
    # https://docs.aws.amazon.com/securityhub/latest/userguide/s3-controls.html#s3-5
    attach_deny_insecure_transport_policy    = optional(bool, true)
    attach_require_latest_tls_policy         = optional(bool, false)
    policy                                   = optional(string)
    attach_policy                            = optional(bool, false)
    attach_public_policy                     = optional(bool, true)
    attach_inventory_destination_policy      = optional(bool, false)
    attach_analytics_destination_policy      = optional(bool, false)
    attach_deny_incorrect_encryption_headers = optional(bool, false)
    attach_deny_incorrect_kms_key_sse        = optional(bool, false)
    acl                                      = optional(string)

    allowed_kms_key_arn                    = optional(string)
    attach_deny_unencrypted_object_uploads = optional(bool, false)

    bucket        = optional(string)
    bucket_prefix = optional(string)

    acceleration_status = optional(string)
    request_payer       = optional(string)
    website             = optional(any, {})

    cors_rule = optional(any, [])
    # [S3.14] S3 general purpose buckets should have versioning enabled
    # https://docs.aws.amazon.com/securityhub/latest/userguide/s3-controls.html#s3-14
    versioning = optional(map(string), {
      enabled = true
    })
    # [S3.9] Server access logging should be enabled for S3 general purpose buckets
    # https://docs.aws.amazon.com/securityhub/latest/userguide/s3-controls.html#s3-9
    logging = map(string)

    default_lifecycle_rules   = optional(list(string), ["retain-x-delete-others"]) # Choose one of the predifined lifecycle rules
    lifecycle_rule            = optional(any, [])
    replication_configuration = optional(any, {})
    # [DEPRECATED] [S3.4] S3 buckets should have server-side encryption enabled
    # https://docs.aws.amazon.com/securityhub/latest/userguide/s3-controls.html#s3-4
    # ATTENTION: Amazon S3 now provides default encryption with S3 managed keys (SSE-S3) on new and existing S3 buckets.
    # The encryption settings are unchanged for existing buckets that are encrypted with SSE-S3 or SSE-KMS server-side encryption.
    server_side_encryption_configuration = optional(any, {})
    intelligent_tiering                  = optional(any, {})
    object_lock_configuration            = optional(any, {})
    metric_configuration                 = optional(any, {})
    inventory_configuration              = optional(any, {})

    access_log_delivery_policy_source_buckets  = optional(list(string), [])
    access_log_delivery_policy_source_accounts = optional(list(string), [])

    grant                 = optional(any, [])
    owner                 = optional(map(string), {})
    expected_bucket_owner = optional(string)

    inventory_source_account_id       = optional(string)
    inventory_source_bucket_arn       = optional(string)
    inventory_self_source_destination = optional(bool, false)

    # ---
    # [S3.8] S3 general purpose buckets should block public access
    # https://docs.aws.amazon.com/securityhub/latest/userguide/s3-controls.html#s3-8
    block_public_acls       = optional(bool, true)
    block_public_policy     = optional(bool, true)
    ignore_public_acls      = optional(bool, true)
    restrict_public_buckets = optional(bool, true)
    # ---

    analytics_configuration           = optional(any, [])
    analytics_source_account_id       = optional(string)
    analytics_source_bucket_arn       = optional(string)
    analytics_self_source_destination = optional(bool, false)

    control_object_ownership = optional(bool, false)
    object_ownership         = optional(string, "BucketOwnerEnforced")
    object_lock_enabled      = optional(bool, false)
    force_destroy            = optional(bool, false)
    tags                     = optional(map(string), {})
  })
}

variable "s3_notification" {
  description = "Configuration block for S3 Notification with secure defaults. Check description of inputs on https://github.com/terraform-aws-modules/terraform-aws-s3-bucket/tree/v3.15.1/modules/notification#inputs website."
  type = object({
    # [S3.11] S3 general purpose buckets should have event notifications enabled
    # https://docs.aws.amazon.com/securityhub/latest/userguide/s3-controls.html#s3-11
    create = optional(bool, true)
    # We disable the policy creation to avoid accidental overriding the existing policy.
    create_sns_policy = optional(bool, false)
    create_sqs_policy = optional(bool, false)

    eventbridge          = optional(bool, false)
    lambda_notifications = optional(any, {})
    sqs_notifications    = optional(any, {})
    sns_notifications    = optional(any, {})
  })
  default = {}
}
