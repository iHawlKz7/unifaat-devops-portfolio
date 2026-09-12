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

variable "db_name" {
  description = "Nome do banco"
  type        = string
  default     = "technova"
}

variable "db_username" {
  description = "Usuário do PostgreSQL"
  type        = string
  default     = "technova_admin"
}

variable "db_password" {
  description = "Senha do PostgreSQL"
  type        = string
  sensitive   = true
}
