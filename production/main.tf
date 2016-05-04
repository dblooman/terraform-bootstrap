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
  public_subnet_a_id = "${module.subnets.public_subnet_a_id}"
  public_subnet_b_id = "${module.subnets.public_subnet_b_id}"
  aws_vpc_id = "${aws_vpc.production.id}"
}

/*module "sentry" {
  source = "../modules/sentry"

  aws_vpc_id = "${aws_vpc.production.id}"
  vpc_dns_zone_id = "${aws_route53_zone.production.zone_id}"

  private_subnet_a_id = "${module.subnets.private_subnet_a_id}"
  private_subnet_b_id = "${module.subnets.private_subnet_b_id}"
  private_subnet_c_id = "${module.subnets.private_subnet_c_id}"

  public_subnet_a_id = "${module.subnets.public_subnet_a_id}"
  public_subnet_b_id = "${module.subnets.public_subnet_b_id}"
  public_subnet_c_id = "${module.subnets.public_subnet_c_id}"

  cache_node_type   = "cache.t2.small"
  db_instance_class = "db.t2.micro"
  instance_type     = "t2.medium"

  sentry_ami              = "ami-id"
  sentry_db_root_password = "password"

}*/

/*module "nexus" {
  source = "../modules/nexus"

  vpc_id     = "${var.shared_services_vpc_id}"
  production_vpc_dns_zone_id = "${aws_route53_zone.production.zone_id}"

  private_subnet_a_id = "${module.subnets.private_subnet_a_id}"
  private_subnet_b_id = "${module.subnets.private_subnet_b_id}"
  private_subnet_c_id = "${module.subnets.private_subnet_c_id}"

  public_subnet_a_id = "${module.subnets.public_subnet_a_id}"
  public_subnet_b_id = "${module.subnets.public_subnet_b_id}"
  public_subnet_c_id = "${module.subnets.public_subnet_c_id}"

  instance_type = "t2.medium"

  nexus_ami = "ami-id"
  key_name = "key-name"

  availability_zones = "eu-west-1a,eu-west-1b,eu-west-1c"

  s3_bucket = "bucket-name"
}*/
