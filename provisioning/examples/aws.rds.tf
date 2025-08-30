resource "random_string" "db-password" {
  length  = 8
  special = false
}

resource "aws_db_instance" "main" {
  allocated_storage       = 10
  db_name                 = "app_rds"
  db_subnet_group_name    = aws_db_subnet_group.main.name
  engine                  = "mysql"
  engine_version          = "8.0"
  identifier              = "main"
  instance_class          = "db.t3.micro"
  username                = "admin"
  password                = random_string.db-password.result
  parameter_group_name    = "default.mysql8.0"
  skip_final_snapshot     = true
  backup_retention_period = 1
  enabled_cloudwatch_logs_exports = [
    "error",
    "general",
    "slowquery"
  ]
  vpc_security_group_ids = [
    aws_security_group.allow-any-from-vpc.id,
  ]
}

resource "aws_db_subnet_group" "main" {
  name       = "main"
  subnet_ids = tolist(aws_subnet.private.*.id)
}

resource "aws_db_instance" "replica" {
  replicate_source_db = aws_db_instance.main.arn
  identifier          = "replica"
  instance_class      = "db.t3.micro"
  skip_final_snapshot = true
  enabled_cloudwatch_logs_exports = [
    "error",
    "general",
    "slowquery"
  ]
  vpc_security_group_ids = [
    aws_security_group.allow-any-from-vpc.id,
  ]
}
