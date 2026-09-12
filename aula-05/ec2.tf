data "aws_ami" "amazon_linux" {
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

resource "aws_key_pair" "main" {
  key_name   = "technova-aula05-key"
  public_key = file(pathexpand("~/.ssh/technova-key.pub"))

  tags = merge(local.common_tags, {
    Name = "technova-aula05-key"
  })
}

resource "aws_instance" "api" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"

  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.ec2.id]
  associate_public_ip_address = true

  key_name = aws_key_pair.main.key_name

  user_data = <<-EOF2
    #!/bin/bash
    set -eux
    dnf install -y postgresql15
  EOF2

  user_data_replace_on_change = true

  depends_on = [
    aws_route_table_association.public
  ]

  tags = merge(local.common_tags, {
    Name = "technova-api"
  })
}
