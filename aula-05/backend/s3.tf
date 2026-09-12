locals {
  state_bucket_name = "technova-tfstate-508379315632-6325192"
}

# O AWS Academy bloqueia s3:GetBucketObjectLockConfiguration.
# Por isso o bucket base é criado via AWS CLI dentro do Terraform,
# evitando a leitura de Object Lock feita por aws_s3_bucket.
resource "terraform_data" "state_bucket" {
  input = local.state_bucket_name

  provisioner "local-exec" {
    command = <<-EOT
      aws s3api create-bucket \
        --bucket "${self.input}" \
        --region us-east-1

      aws s3api put-bucket-tagging \
        --bucket "${self.input}" \
        --tagging 'TagSet=[{Key=Name,Value=technova-terraform-state},{Key=Project,Value=TechNova},{Key=Aula,Value=05},{Key=Owner,Value=6325192},{Key=Purpose,Value=Terraform-Remote-State}]'
    EOT
  }

  provisioner "local-exec" {
    when = destroy

    command = <<-EOT
      aws s3api delete-bucket \
        --bucket "${self.output}" \
        --region us-east-1
    EOT
  }
}

resource "aws_s3_bucket_versioning" "state" {
  bucket = terraform_data.state_bucket.output

  versioning_configuration {
    status = "Enabled"
  }

  depends_on = [
    terraform_data.state_bucket
  ]
}

resource "aws_s3_bucket_server_side_encryption_configuration" "state" {
  bucket = terraform_data.state_bucket.output

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "aws:kms"
    }
  }

  depends_on = [
    terraform_data.state_bucket
  ]
}

resource "aws_s3_bucket_public_access_block" "state" {
  bucket = terraform_data.state_bucket.output

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  depends_on = [
    terraform_data.state_bucket
  ]
}
