locals {
  # [S3.13] S3 general purpose buckets should have Lifecycle configurations
  # https://docs.aws.amazon.com/securityhub/latest/userguide/s3-controls.html#s3-13
  # [S3.10] S3 general purpose buckets with versioning enabled should have Lifecycle configurations
  # https://docs.aws.amazon.com/securityhub/latest/userguide/s3-controls.html#s3-10
  s3_lifecycle_rules = {
    retain-x-delete-others = {
      id      = "retain-x-delete-others"
      enabled = true

      noncurrent_version_expiration = {
        days                      = 1
        newer_noncurrent_versions = 5
      }
    }

    auto-archive = {
      id      = "auto-archive"
      enabled = true

      transition = {
        days          = 90
        storage_class = "GLACIER"
      }

      noncurrent_version_transition = {
        days          = 90
        storage_class = "GLACIER"
      }

      expiration = {
        days = 365
      }

      noncurrent_version_expiration = {
        days = 365
      }
    }
  }
}