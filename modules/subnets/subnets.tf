variable "aws_vpc_id" {}
variable "environment" {}

resource "aws_subnet" "public_subnet_a" {
  vpc_id            = "${var.aws_vpc_id}"
  availability_zone = "eu-west-1a"
  cidr_block        = "10.10.0.0/24"

  tags {
    Name        = "Public Subnet A"
    Environment = "${var.environment}"
  }
}

resource "aws_subnet" "public_subnet_b" {
  vpc_id            = "${var.aws_vpc_id}"
  availability_zone = "eu-west-1b"
  cidr_block        = "10.10.1.0/24"

  tags {
    Name        = "Public Subnet B"
    Environment = "${var.environment}"
  }
}

resource "aws_subnet" "public_subnet_c" {
  vpc_id            = "${var.aws_vpc_id}"
  availability_zone = "eu-west-1c"
  cidr_block        = "10.10.2.0/24"

  tags {
    Name        = "Public Subnet C"
    Environment = "${var.environment}"
  }
}

resource "aws_subnet" "private_subnet_a" {
  vpc_id            = "${var.aws_vpc_id}"
  availability_zone = "eu-west-1a"
  cidr_block        = "10.10.10.0/24"

  tags {
    Name        = "Private Subnet A"
    Environment = "${var.environment}"
  }
}

resource "aws_subnet" "private_subnet_b" {
  vpc_id            = "${var.aws_vpc_id}"
  availability_zone = "eu-west-1b"
  cidr_block        = "10.10.11.0/24"

  tags {
    Name        = "Private Subnet B"
    Environment = "${var.environment}"
  }
}

resource "aws_subnet" "private_subnet_c" {
  vpc_id            = "${var.aws_vpc_id}"
  availability_zone = "eu-west-1c"
  cidr_block        = "10.10.12.0/24"

  tags {
    Name        = "Private Subnet C"
    Environment = "${var.environment}"
  }
}

output "public_subnet_a_id" {
  value = "${aws_subnet.public_subnet_a.id}"
}

output "public_subnet_b_id" {
  value = "${aws_subnet.public_subnet_b.id}"
}

output "public_subnet_c_id" {
  value = "${aws_subnet.public_subnet_c.id}"
}

output "private_subnet_a_id" {
  value = "${aws_subnet.private_subnet_a.id}"
}

output "private_subnet_b_id" {
  value = "${aws_subnet.private_subnet_b.id}"
}

output "private_subnet_c_id" {
  value = "${aws_subnet.private_subnet_c.id}"
}
