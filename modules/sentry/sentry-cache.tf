variable "private_subnet_a_id" {}

variable "private_subnet_b_id" {}

variable "private_subnet_c_id" {}

variable "aws_vpc_id" {}

variable "cache_node_type" {}

resource "aws_elasticache_parameter_group" "sentry" {
  name        = "sentry-cache"
  family      = "redis2.8"
  description = "Cache cluster for sentry"
}

resource "aws_elasticache_subnet_group" "sentry" {
  name        = "sentry"
  description = "Sentry Elasticache Subnet Group"

  subnet_ids = [
    "${var.private_subnet_a_id}",
    "${var.private_subnet_b_id}",
    "${var.private_subnet_c_id}",
  ]
}

resource "aws_elasticache_cluster" "sentry" {
  cluster_id           = "sentry-cache"
  engine               = "redis"
  node_type            = "${var.cache_node_type}"
  port                 = 6379
  num_cache_nodes      = 1
  parameter_group_name = "${aws_elasticache_parameter_group.sentry.name}"
  subnet_group_name    = "${aws_elasticache_subnet_group.sentry.name}"

  security_group_ids = [
    "${aws_security_group.sentry_cache.id}",
  ]
}

resource "aws_security_group" "sentry_cache" {
  vpc_id      = "${var.aws_vpc_id}"
  name        = "Sentry Cache"
  description = "Sentry Elasticache Redis Instance"

  tags {
    Name        = "Sentry Cache"
    Environment = "Production"
  }
}

# Sentry Cache <-(?, TCP 6379)-> Internet
resource "aws_security_group_rule" "sentry_cache_in" {
  type      = "ingress"
  from_port = 6379
  to_port   = 6379
  protocol  = "tcp"

  source_security_group_id = "${aws_security_group.sentry.id}"
  security_group_id        = "${aws_security_group.sentry_cache.id}"
}

resource "aws_security_group_rule" "sentry_cache_out" {
  type      = "egress"
  from_port = 6379
  to_port   = 6379
  protocol  = "tcp"

  source_security_group_id = "${aws_security_group.sentry.id}"
  security_group_id        = "${aws_security_group.sentry_cache.id}"
}
