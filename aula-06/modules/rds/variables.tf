variable "db_name" {
  description = "Nome do database"
  type        = string
}

variable "db_username" {
  description = "Usuario master"
  type        = string
}

variable "db_password" {
  description = "Senha master"
  type        = string
  sensitive   = true
}

variable "subnet_ids" {
  description = "Subnets privadas"
  type        = list(string)
}

variable "security_group_ids" {
  description = "Security Groups do RDS"
  type        = list(string)
}

variable "instance_class" {
  description = "Classe da instancia RDS"
  type        = string
  default     = "db.t3.micro"
}

variable "environment" {
  description = "Ambiente"
  type        = string
}

variable "project_name" {
  description = "Nome do projeto"
  type        = string
}
