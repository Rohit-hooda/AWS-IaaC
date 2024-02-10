resource "aws_db_instance" "postgresql_instance" {
  identifier             = var.db_identifier
  engine                 = var.db_engine
  engine_version         = var.db_engine_version
  instance_class         = var.db_instance_class
  db_name                = var.db_name
  username               = var.db_username
  password               = var.db_password
  allocated_storage      = var.db_allocated_storage
  parameter_group_name   = aws_db_parameter_group.postgresql_parameters.name
  db_subnet_group_name   = aws_db_subnet_group.private_db_subnet.name
  publicly_accessible    = false
  skip_final_snapshot    = true
  vpc_security_group_ids = [aws_security_group.database_security_group.id]
  storage_encrypted      = true
  kms_key_id             = aws_kms_key.kms_rds.arn
}
resource "aws_db_parameter_group" "postgresql_parameters" {
  name        = var.db_pg_name
  family      = var.db_pg_family
  description = var.db_pg_description
}

resource "aws_db_subnet_group" "private_db_subnet" {
  name       = "private"
  subnet_ids = ["${aws_subnet.private_subnet[0].id}", "${aws_subnet.private_subnet[1].id}"]
}

resource "aws_security_group" "database_security_group" {
  name_prefix = "database-sg"
  vpc_id      = aws_vpc.vpc.id
  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.instance.id]
  }

}

resource "aws_kms_key" "kms_rds" {
  description             = "KMS key for RDS"
  policy                  = local.policy_kms_json
  enable_key_rotation     = true
  deletion_window_in_days = 7
}