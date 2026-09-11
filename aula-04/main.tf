data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

locals {
  common_tags = {
    Project     = "TechNova"
    Environment = "development"
    ManagedBy   = "Terraform"
    Owner       = var.owner_ra
  }
}

resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(local.common_tags, {
    Name = "technova-vpc"
  })
}

# ============================================================
# SUBNETS PÚBLICAS - 2 AZs
# ============================================================

resource "aws_subnet" "public" {
  count = 2

  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = merge(local.common_tags, {
    Name = "technova-public-subnet-${count.index + 1}"
    Type = "public"
  })
}

# ============================================================
# SUBNETS PRIVADAS - 2 AZs
# ============================================================

resource "aws_subnet" "private" {
  count = 2

  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.private_subnet_cidrs[count.index]
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = false

  tags = merge(local.common_tags, {
    Name = "technova-private-subnet-${count.index + 1}"
    Type = "private"
  })
}

# ============================================================
# INTERNET GATEWAY
# ============================================================

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = merge(local.common_tags, {
    Name = "technova-igw"
  })
}

# ============================================================
# ROUTE TABLE PÚBLICA
# ============================================================

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = merge(local.common_tags, {
    Name = "technova-public-rt"
  })
}

resource "aws_route_table_association" "public" {
  count = 2

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# ============================================================
# SECURITY GROUP - API
# ============================================================

resource "aws_security_group" "api" {
  name        = "technova-api-sg"
  description = "Security Group da API TechNova"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "API Node.js"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Todo trafego de saida"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, {
    Name = "technova-api-sg"
  })
}

# ============================================================
# SECURITY GROUP - BANCO
# ============================================================

resource "aws_security_group" "db" {
  name        = "technova-db-sg"
  description = "Security Group do banco de dados"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "PostgreSQL interno"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    description = "Todo trafego de saida"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, {
    Name = "technova-db-sg"
  })
}

# ============================================================
# KEY PAIR
# ============================================================

resource "aws_key_pair" "main" {
  key_name   = "technova-key"
  public_key = file(pathexpand("~/.ssh/technova-key.pub"))

  tags = merge(local.common_tags, {
    Name = "technova-key"
  })
}

# ============================================================
# IAM
# No AWS Academy usamos LabInstanceProfile.
# A implementação abaixo fica no código para atender ao TF.
# ============================================================

resource "aws_iam_role" "ec2" {
  count = var.create_custom_iam ? 1 : 0

  name = "technova-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "ec2.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = merge(local.common_tags, {
    Name = "technova-ec2-role"
  })
}

resource "aws_iam_role_policy_attachment" "s3_read_only" {
  count = var.create_custom_iam ? 1 : 0

  role       = aws_iam_role.ec2[0].name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

resource "aws_iam_instance_profile" "ec2" {
  count = var.create_custom_iam ? 1 : 0

  name = "technova-ec2-profile"
  role = aws_iam_role.ec2[0].name

  tags = merge(local.common_tags, {
    Name = "technova-ec2-profile"
  })
}

# ============================================================
# EC2
# ============================================================

resource "aws_instance" "api" {
  ami           = data.aws_ami.amazon_linux_2023.id
  instance_type = "t2.micro"

  subnet_id                   = aws_subnet.public[0].id
  vpc_security_group_ids      = [aws_security_group.api.id]
  associate_public_ip_address = true

  key_name = aws_key_pair.main.key_name

  iam_instance_profile = var.create_custom_iam ? aws_iam_instance_profile.ec2[0].name : "LabInstanceProfile"

  user_data = templatefile("${path.module}/user_data.sh", {
    repository_url    = var.repository_url
    repository_branch = var.repository_branch
  })

  user_data_replace_on_change = true

  root_block_device {
    volume_size = 8
    volume_type = "gp2"
  }

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  volume_tags = merge(local.common_tags, {
    Name = "technova-api-disk"
  })

  tags = merge(local.common_tags, {
    Name = "technova-api"
  })
}
