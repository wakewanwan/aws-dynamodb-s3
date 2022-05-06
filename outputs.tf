output "s3_bucket" {
  description = "value of the s3_bucket"
  value       = aws_s3_bucket.s3_bucket.id
}

output "dynamodb_table" {
  description = "value of the dynamodb_table"
  value       = aws_dynamodb_table.terraform-dynamodb-table.id
}

output "config" {
  description = "Outputs the configuration for s3 backend"
  value = {
    bucket         = aws_s3_bucket.s3_bucket.bucket
    region         = data.aws_region.current.name
    role_arn       = aws_iam_role.iam_role.arn
    dynamodb_table = aws_dynamodb_table.terraform-dynamodb-table.name
  }
}
