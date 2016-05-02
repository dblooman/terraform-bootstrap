provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}

# VPC
resource "aws_vpc" "production" {
  cidr_block           = "10.10.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags {
    Name = "Production"
  }
}

# Modules
module "iam" {
  source = "../modules/iam"
  account_id = "${var.account_id}"
}

module "subnets" {
  source = "../modules/subnets"
  aws_vpc_id = "${aws_vpc.production.id}"
  environment = "production"
}

module "nats" {
  source =  "../modules/nats"
  aws_subnet_public_subnet_a_id = "${module.subnets.public_subnet_a_id}"
  aws_subnet_public_subnet_b_id = "${module.subnets.public_subnet_b_id}"
  aws_vpc_id = "${aws_vpc.production.id}"
}
