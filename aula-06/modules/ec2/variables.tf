variable "instance_name" {
  description = "Nome da instancia"
  type        = string
}

variable "instance_type" {
  description = "Tipo da instancia"
  type        = string
  default     = "t2.micro"
}

variable "ami_id" {
  description = "AMI ID"
  type        = string
}

variable "subnet_id" {
  description = "Subnet da instancia"
  type        = string
}

variable "security_group_ids" {
  description = "Security Groups da instancia"
  type        = list(string)
}

variable "key_name" {
  description = "Nome da Key Pair"
  type        = string
  default     = null
}

variable "user_data" {
  description = "User data opcional"
  type        = string
  default     = null
}

variable "environment" {
  description = "Ambiente"
  type        = string
}

variable "project_name" {
  description = "Nome do projeto"
  type        = string
}
