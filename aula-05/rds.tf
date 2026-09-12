resource "aws_db_subnet_group" "main" {
  name = "technova-db-subnet-group"

  subnet_ids = [
    aws_subnet.private_1.id,
    aws_subnet.private_2.id
  ]

  tags = merge(local.common_tags, {
    Name = "technova-db-subnet-group"
  })
}

resource "aws_db_instance" "main" {
  identifier = "technova-db"

  engine         = "postgres"
  engine_version = "15"

  instance_class    = "db.t3.micro"
  allocated_storage = 20
  storage_type      = "gp2"

  db_name  = var.db_name
  username = var.db_username
  password = var.db_password
  port     = 5432

  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.rds.id]

  publicly_accessible = false
  multi_az            = false

  storage_encrypted = true

  skip_final_snapshot = true
  deletion_protection = false

  apply_immediately = true

  tags = merge(local.common_tags, {
    Name = "technova-rds"
  })
}
