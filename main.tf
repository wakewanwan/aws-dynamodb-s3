data "aws_region" "current" {}

data "aws_kms_key" "s3" {
  key_id = "alias/aws/s3"
}

resource "aws_resourcegroups_group" "resourcegroups_group" {
  name = "${var.namespace}-group"

  resource_query {
    query = <<-JSON
{
  "ResourceTypeFilters": [
    "AWS::AllSupported"
  ],
  "TagFilters": [
    {
      "Key": "ResourceGroup",
      "Values": ["${var.namespace}"]
    }
  ]
}
JSON
  }
}


resource "aws_s3_bucket" "s3_bucket" {
  bucket        = "state-bucket-${var.namespace}"
  force_destroy = var.force_destroy_state
  acl           = "private"

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = data.aws_kms_key.s3.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }

  tags = {
    ResourceGroup = "${var.namespace}"
  }
}

resource "aws_s3_bucket_public_access_block" "s3_bucket" {
  bucket        = aws_s3_bucket.s3_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
  ignore_public_acls      = true
}


resource "aws_dynamodb_table" "terraform-dynamodb-table" {
  name           = "state-lock-${var.namespace}"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    ResourceGroup = "${var.namespace}"
  }
}
