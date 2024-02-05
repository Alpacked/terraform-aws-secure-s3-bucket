# terraform-aws-secure-s3-bucket

The extended version of the [terraform-aws-s3-bucket](https://github.com/terraform-aws-modules/terraform-aws-s3-bucket) public module with additional features.

<!-- BEGIN_AUTOMATED_TF_DOCS_BLOCK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_s3_notification"></a> [s3\_notification](#module\_s3\_notification) | terraform-aws-modules/s3-bucket/aws//modules/notification | 3.15.1 |
| <a name="module_secure_s3"></a> [secure\_s3](#module\_secure\_s3) | terraform-aws-modules/s3-bucket/aws | 3.15.1 |

## Resources

| Name | Type |
|------|------|
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_s3"></a> [s3](#input\_s3) | Configuration block for S3 with secure defaults. Check description of inputs on https://github.com/terraform-aws-modules/terraform-aws-s3-bucket/tree/v3.15.1#inputs website. | <pre>object({<br>    create_bucket = optional(bool, true)<br><br>    attach_elb_log_delivery_policy    = optional(bool, false)<br>    attach_lb_log_delivery_policy     = optional(bool, false)<br>    attach_access_log_delivery_policy = optional(bool, false)<br><br>    # [S3.5] S3 buckets should require requests to use Secure Socket Layer<br>    # https://docs.aws.amazon.com/securityhub/latest/userguide/s3-controls.html#s3-5<br>    attach_deny_insecure_transport_policy    = optional(bool, true)<br>    attach_require_latest_tls_policy         = optional(bool, false)<br>    policy                                   = optional(string)<br>    attach_policy                            = optional(bool, false)<br>    attach_public_policy                     = optional(bool, true)<br>    attach_inventory_destination_policy      = optional(bool, false)<br>    attach_analytics_destination_policy      = optional(bool, false)<br>    attach_deny_incorrect_encryption_headers = optional(bool, false)<br>    attach_deny_incorrect_kms_key_sse        = optional(bool, false)<br>    acl                                      = optional(string)<br><br>    allowed_kms_key_arn                    = optional(string)<br>    attach_deny_unencrypted_object_uploads = optional(bool, false)<br><br>    bucket        = optional(string)<br>    bucket_prefix = optional(string)<br><br>    acceleration_status = optional(string)<br>    request_payer       = optional(string)<br>    website             = optional(any, {})<br><br>    cors_rule = optional(any, [])<br>    # [S3.14] S3 general purpose buckets should have versioning enabled<br>    # https://docs.aws.amazon.com/securityhub/latest/userguide/s3-controls.html#s3-14<br>    versioning = optional(map(string), {<br>      enabled = true<br>    })<br>    # [S3.9] Server access logging should be enabled for S3 general purpose buckets<br>    # https://docs.aws.amazon.com/securityhub/latest/userguide/s3-controls.html#s3-9<br>    logging = map(string)<br><br>    default_lifecycle_rules   = optional(list(string), ["retain-x-delete-others"]) # Choose one of the predifined lifecycle rules<br>    lifecycle_rule            = optional(any, [])<br>    replication_configuration = optional(any, {})<br>    # [DEPRECATED] [S3.4] S3 buckets should have server-side encryption enabled<br>    # https://docs.aws.amazon.com/securityhub/latest/userguide/s3-controls.html#s3-4<br>    # ATTENTION: Amazon S3 now provides default encryption with S3 managed keys (SSE-S3) on new and existing S3 buckets.<br>    # The encryption settings are unchanged for existing buckets that are encrypted with SSE-S3 or SSE-KMS server-side encryption.<br>    server_side_encryption_configuration = optional(any, {})<br>    intelligent_tiering                  = optional(any, {})<br>    object_lock_configuration            = optional(any, {})<br>    metric_configuration                 = optional(any, {})<br>    inventory_configuration              = optional(any, {})<br><br>    access_log_delivery_policy_source_buckets  = optional(list(string), [])<br>    access_log_delivery_policy_source_accounts = optional(list(string), [])<br><br>    grant                 = optional(any, [])<br>    owner                 = optional(map(string), {})<br>    expected_bucket_owner = optional(string)<br><br>    inventory_source_account_id       = optional(string)<br>    inventory_source_bucket_arn       = optional(string)<br>    inventory_self_source_destination = optional(bool, false)<br><br>    # ---<br>    # [S3.8] S3 general purpose buckets should block public access<br>    # https://docs.aws.amazon.com/securityhub/latest/userguide/s3-controls.html#s3-8<br>    block_public_acls       = optional(bool, true)<br>    block_public_policy     = optional(bool, true)<br>    ignore_public_acls      = optional(bool, true)<br>    restrict_public_buckets = optional(bool, true)<br>    # ---<br><br>    analytics_configuration           = optional(any, [])<br>    analytics_source_account_id       = optional(string)<br>    analytics_source_bucket_arn       = optional(string)<br>    analytics_self_source_destination = optional(bool, false)<br><br>    control_object_ownership = optional(bool, false)<br>    object_ownership         = optional(string, "BucketOwnerEnforced")<br>    object_lock_enabled      = optional(bool, false)<br>    force_destroy            = optional(bool, false)<br>    tags                     = optional(map(string), {})<br>  })</pre> | n/a | yes |
| <a name="input_s3_notification"></a> [s3\_notification](#input\_s3\_notification) | Configuration block for S3 Notification with secure defaults. Check description of inputs on https://github.com/terraform-aws-modules/terraform-aws-s3-bucket/tree/v3.15.1/modules/notification#inputs website. | <pre>object({<br>    # [S3.11] S3 general purpose buckets should have event notifications enabled<br>    # https://docs.aws.amazon.com/securityhub/latest/userguide/s3-controls.html#s3-11<br>    create = optional(bool, true)<br>    # We disable the policy creation to avoid accidental overriding the existing policy.<br>    create_sns_policy = optional(bool, false)<br>    create_sqs_policy = optional(bool, false)<br><br>    eventbridge          = optional(bool, false)<br>    lambda_notifications = optional(any, {})<br>    sqs_notifications    = optional(any, {})<br>    sns_notifications    = optional(any, {})<br>  })</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_s3"></a> [s3](#output\_s3) | Get all outputs from the S3 public module. Check https://github.com/terraform-aws-modules/terraform-aws-s3-bucket/tree/v3.15.1#outputs for possible outputs. |
| <a name="output_s3_notification"></a> [s3\_notification](#output\_s3\_notification) | Get all outputs from the S3 Notification public module. Check https://github.com/terraform-aws-modules/terraform-aws-s3-bucket/tree/v3.15.1/modules/notification#outputs for possible outputs. |
<!-- END_AUTOMATED_TF_DOCS_BLOCK -->