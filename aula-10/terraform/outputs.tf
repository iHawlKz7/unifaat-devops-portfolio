output "ec2_instance_id" {
  description = "ID da instancia EC2 da TechNova"
  value       = aws_instance.technova_api.id
}

output "ec2_public_ip" {
  description = "IP publico para deploy e health check"
  value       = aws_instance.technova_api.public_ip
}

output "security_group_id" {
  description = "Security Group da API"
  value       = aws_security_group.technova_api.id
}

output "vpc_id" {
  description = "ID da VPC criada para a Aula 10"
  value       = aws_vpc.technova.id
}

output "ecr_repository_uri" {
  description = "URI do repositorio ECR usado pelo pipeline"
  value       = "924308937786.dkr.ecr.us-east-1.amazonaws.com/technova-api"
}
