data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

module "vpc" {
  source = "../../modules/vpc"

  vpc_cidr     = "10.0.0.0/16"
  project_name = "technova"
  environment  = "dev"

  subnets = {
    public-1 = {
      cidr = "10.0.1.0/24"
      az   = "us-east-1a"
      type = "public"
    }
    public-2 = {
      cidr = "10.0.2.0/24"
      az   = "us-east-1b"
      type = "public"
    }
    private-1 = {
      cidr = "10.0.3.0/24"
      az   = "us-east-1a"
      type = "private"
    }
    private-2 = {
      cidr = "10.0.4.0/24"
      az   = "us-east-1b"
      type = "private"
    }
  }
}

module "api_sg" {
  source = "../../modules/security-group"

  name         = "technova-dev-api-sg"
  vpc_id       = module.vpc.vpc_id
  environment  = "dev"
  project_name = "technova"

  ingress_rules = [
    {
      description     = "HTTP API"
      from_port       = 3000
      to_port         = 3000
      protocol        = "tcp"
      cidr_blocks     = ["0.0.0.0/0"]
      security_groups = []
    }
  ]
}

module "rds_sg" {
  source = "../../modules/security-group"

  name         = "technova-dev-rds-sg"
  vpc_id       = module.vpc.vpc_id
  environment  = "dev"
  project_name = "technova"

  ingress_rules = [
    {
      description     = "PostgreSQL da EC2"
      from_port       = 5432
      to_port         = 5432
      protocol        = "tcp"
      cidr_blocks     = []
      security_groups = [module.api_sg.sg_id]
    }
  ]
}

module "api_server" {
  source = "../../modules/ec2"

  instance_name      = "technova-dev-api"
  instance_type      = "t2.micro"
  ami_id             = data.aws_ami.amazon_linux.id
  subnet_id          = module.vpc.public_subnet_ids[0]
  security_group_ids = [module.api_sg.sg_id]
  environment        = "dev"
  project_name       = "technova"
}

module "database" {
  source = "../../modules/rds"

  db_name            = "technova_dev"
  db_username        = "postgres"
  db_password        = var.db_password
  subnet_ids         = module.vpc.private_subnet_ids
  security_group_ids = [module.rds_sg.sg_id]
  instance_class     = "db.t3.micro"
  environment        = "dev"
  project_name       = "technova"
}
