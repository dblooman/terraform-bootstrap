variable "public_subnet_a_id" {}
variable "public_subnet_b_id" {}
variable "aws_vpc_id" {}

# Internet Gateway
resource "aws_internet_gateway" "production" {
  vpc_id = "${var.aws_vpc_id}"

  tags {
    Name = "Production"
  }
}

resource "aws_eip" "nat_gateway_a" {
  vpc = true
}

resource "aws_nat_gateway" "nat_gateway_a" {
  allocation_id = "${aws_eip.nat_gateway_a.id}"
  subnet_id     = "${var.public_subnet_a_id}"
  depends_on    = ["aws_internet_gateway.production"]
}

resource "aws_eip" "nat_gateway_b" {
  vpc = true
}

resource "aws_nat_gateway" "nat_gateway_b" {
  allocation_id = "${aws_eip.nat_gateway_b.id}"
  subnet_id     = "${var.public_subnet_b_id}"
  depends_on    = ["aws_internet_gateway.production"]
}

output "nat_gateway_a_id" {
  value = "${aws_nat_gateway.nat_gateway_a.id}"
}

output "nat_gateway_b_id" {
  value = "${aws_nat_gateway.nat_gateway_b.id}"
}

output "aws_internet_gateway_id" {
  value = "${aws_internet_gateway.production.id}"
}

output "production_internet_gateway_id" {
  value = "${aws_internet_gateway.production.id}"
}
