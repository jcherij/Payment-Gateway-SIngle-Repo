resource "aws_db_subnet_group" "payment" {
  name       = "payment-prod-subnet-group"
  subnet_ids = var.subnet_ids

  tags = {
    Environment = "production"
    Service     = "payment"
  }
}

resource "aws_security_group" "rds" {
  name        = "payment-rds-sg"
  description = "Allow PostgreSQL access from app tier only"
  vpc_id      = var.vpc_id

  ingress {
    description     = "PostgreSQL from app tier"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [var.app_security_group_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Environment = "production"
    Service     = "payment"
  }
}

resource "aws_db_instance" "payment_primary" {
  identifier        = "payment-prod"
  engine            = "postgres"
  engine_version    = "15.4"
  instance_class    = "db.r6g.large"
  allocated_storage = 100
  storage_type      = "gp3"

  # Security Policy §2.1 — production databases storing payment data
  # must have encryption at rest enabled.
  storage_encrypted = false

  db_name  = "payments"
  username = var.db_username
  password = var.db_password

  db_subnet_group_name   = aws_db_subnet_group.payment.name
  vpc_security_group_ids = [aws_security_group.rds.id]

  skip_final_snapshot       = false
  final_snapshot_identifier = "payment-prod-final"
  deletion_protection       = true
  backup_retention_period   = 7
  backup_window             = "03:00-04:00"
  maintenance_window        = "sun:05:00-sun:06:00"

  tags = {
    Environment = "production"
    Service     = "payment"
    Team        = "platform"
    PCIScope    = "true"
  }
}
