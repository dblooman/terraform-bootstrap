variable "aws_vpc_id" {}

variable "vpc_dns_zone_id" {}

variable "private_subnet_a_id" {}

variable "private_subnet_b_id" {}

variable "private_subnet_c_id" {}

variable "db_instance_class" {}

variable "sentry_db_root_password" {}

resource "aws_db_instance" "sentry_db" {
  engine            = "postgres"
  engine_version    = "9.5.2"
  instance_class    = "${var.db_instance_class}"
  multi_az          = true
  storage_type      = "gp2"
  allocated_storage = 10

  identifier = "sentry"
  username   = "root"
  password   = "${var.sentry_db_root_password}"
  name       = "sentry"

  storage_encrypted    = false
  parameter_group_name = "${aws_db_parameter_group.sentry.id}"

  db_subnet_group_name = "shared-services-private"

  vpc_security_group_ids = [
    "${aws_security_group.sentry_db.id}",
  ]

  publicly_accessible = false

  backup_retention_period = 30
  backup_window           = "00:00-01:00"
  maintenance_window      = "Sun:01:00-Sun:02:00"

  tags {
    Name        = "Sentry"
    Environment = "Production"
  }
}

resource "aws_db_parameter_group" "sentry" {
  name        = "sentry"
  family      = "postgres9.5"
  description = "Parameters for Sentry instance of Postgres 9.5"

  tags {
    Environment = "Production"
  }
}

resource "aws_db_subnet_group" "shared_services_private" {
  name        = "shared-services-private"
  description = "Shared Services Private Subnet Group"

  subnet_ids = [
    "${var.private_subnet_a_id}",
    "${var.private_subnet_b_id}",
    "${var.private_subnet_c_id}",
  ]

  tags {
    Environment = "Production"
  }
}

resource "aws_route53_record" "sentry_db" {
  zone_id = "${var.vpc_dns_zone_id}"
  name    = "sentry-db.example.com"
  type    = "CNAME"
  ttl     = "30"
  records = ["${aws_db_instance.sentry_db.address}"]
}

resource "aws_security_group" "sentry_db" {
  vpc_id = "${var.aws_vpc_id}"
  name   = "Sentry DB"

  tags {
    Name        = "Sentry DB"
    Environment = "Production"
  }
}

# Sentry DB <-(PostgreSQL, TCP 5432)-> Sentry
resource "aws_security_group_rule" "sentry_db_sentry_in" {
  type      = "ingress"
  from_port = 5432
  to_port   = 5432
  protocol  = "tcp"

  source_security_group_id = "${aws_security_group.sentry.id}"
  security_group_id        = "${aws_security_group.sentry_db.id}"
}

resource "aws_security_group_rule" "sentry_db_sentry_out" {
  type      = "egress"
  from_port = 5432
  to_port   = 5432
  protocol  = "tcp"

  source_security_group_id = "${aws_security_group.sentry.id}"
  security_group_id        = "${aws_security_group.sentry_db.id}"
}
