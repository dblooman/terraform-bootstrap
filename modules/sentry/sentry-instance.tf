
variable "private_subnet_a_id" {}

variable "private_subnet_b_id" {}

variable "private_subnet_c_id" {}

variable "instance_type" {}

variable "sentry_ami" {}

resource "aws_instance" "sentry" {
  ami           = "${var.sentry_ami}"
  instance_type = "${var.instance_type}"
  subnet_id     = "${var.private_subnet_a_id}"

  vpc_security_group_ids = [
    "${aws_security_group.sentry.id}",
  ]

  key_name = "terraform-production"

  tags {
    Name        = "Sentry"
    Environment = "Production"
  }
}

resource "aws_route53_record" "sentry" {
  zone_id = "${var.production_vpc_dns_zone_id}"
  name    = "sentry.prod.example.com"
  type    = "A"
  ttl     = "60"
  records = ["${aws_instance.sentry.private_ip}"]
}

resource "aws_security_group" "sentry" {
  vpc_id      = "${var.aws_vpc_id}"
  name        = "Sentry"
  description = "Sentry"

  tags {
    Name        = "Sentry"
    Environment = "Production"
  }
}

# Bastion -(SSH 22)-> Sentry
resource "aws_security_group_rule" "sentry_ssh_in" {
  type      = "ingress"
  from_port = 22
  to_port   = 22
  protocol  = "tcp"

  source_security_group_id = "${var.bastion_security_group_id}"
  security_group_id        = "${aws_security_group.sentry.id}"
}

# Sentry -(HTTP, TCP 80)-> Internet
resource "aws_security_group_rule" "sentry_http_out" {
  type      = "egress"
  from_port = 80
  to_port   = 80
  protocol  = "tcp"

  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.sentry.id}"
}

# Sentry -(HTTPS, TCP 443)-> Internet
resource "aws_security_group_rule" "sentry_https_out" {
  type      = "egress"
  from_port = 443
  to_port   = 443
  protocol  = "tcp"

  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.sentry.id}"
}

# Sentry -(Postgres, TCP 5432)-> Sentry DB
resource "aws_security_group_rule" "sentry_postgres_out" {
  type      = "egress"
  from_port = 5432
  to_port   = 5432
  protocol  = "tcp"

  source_security_group_id = "${aws_security_group.sentry_db.id}"
  security_group_id        = "${aws_security_group.sentry.id}"
}

# Sentry -(Redis, TCP 6370)-> Sentry Cache
resource "aws_security_group_rule" "sentry_redis_out" {
  type      = "egress"
  from_port = 6379
  to_port   = 6379
  protocol  = "tcp"

  source_security_group_id = "${aws_security_group.sentry_cache.id}"
  security_group_id        = "${aws_security_group.sentry.id}"
}

output "security_group_id" {
  value = "${aws_security_group.sentry.id}"
}
