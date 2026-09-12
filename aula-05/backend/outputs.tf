output "s3_bucket_name" {
  value = terraform_data.state_bucket.output
}

output "s3_bucket_arn" {
  value = "arn:aws:s3:::${terraform_data.state_bucket.output}"
}

output "dynamodb_table_name" {
  value = aws_dynamodb_table.locks.name
}
