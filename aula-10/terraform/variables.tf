variable "aws_region" {
  description = "Regiao AWS usada no Learner Lab"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Nome do projeto"
  type        = string
  default     = "technova"
}

variable "environment" {
  description = "Ambiente"
  type        = string
  default     = "aula10"
}

variable "instance_type" {
  description = "Tipo da instancia EC2"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "Key Pair usada para SSH"
  type        = string
  default     = "technova-aula10"
}
