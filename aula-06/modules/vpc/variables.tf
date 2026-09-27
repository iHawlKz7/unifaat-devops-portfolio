variable "vpc_cidr" {
  description = "CIDR da VPC"
  type        = string
}

variable "project_name" {
  description = "Nome do projeto"
  type        = string
}

variable "environment" {
  description = "Ambiente"
  type        = string
}

variable "subnets" {
  description = "Mapa de subnets com CIDR, AZ e tipo"
  type = map(object({
    cidr = string
    az   = string
    type = string
  }))
}
