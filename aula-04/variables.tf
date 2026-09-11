variable "aws_region" {
  description = "Região AWS"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Nome do projeto"
  type        = string
  default     = "technova"
}

variable "owner_ra" {
  description = "RA do aluno"
  type        = string
  default     = "6325192"
}

variable "vpc_cidr" {
  description = "CIDR da VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "CIDRs das subnets públicas"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.3.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDRs das subnets privadas"
  type        = list(string)
  default     = ["10.0.2.0/24", "10.0.4.0/24"]
}

variable "repository_url" {
  description = "URL HTTPS do repositório unifaat-devops-portfolio"
  type        = string
}

variable "repository_branch" {
  description = "Branch contendo a aplicação"
  type        = string
  default     = "feature/aula-04-vpc-ec2"
}

variable "create_custom_iam" {
  description = "Criar IAM Role própria fora do AWS Academy"
  type        = bool
  default     = false
}
