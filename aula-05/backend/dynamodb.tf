resource "aws_dynamodb_table" "locks" {
  name         = "technova-tf-locks-6325192"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name    = "technova-terraform-locks"
    Project = "TechNova"
    Aula    = "05"
    Purpose = "Terraform State Lock"
    Owner   = "6325192"
  }
}
