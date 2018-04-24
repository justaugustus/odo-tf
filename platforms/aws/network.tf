/*
VPC 
IGW 
Route table 
default Route 
subnet 
*/

resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"

  tags {
    Name = "main"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name = "main"
  }
}

resource "aws_route_table" "rt" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name = "main"
  }
}

resource "aws_main_route_table_association" "rta" {
  vpc_id         = "${aws_vpc.vpc.id}"
  route_table_id = "${aws_route_table.rt.id}"
}

resource "aws_route" "r" {
  route_table_id         = "${aws_route_table.rt.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.igw.id}"

  #depends_on                = ["aws_route_table.testing"]
}

# TODO: Support multiple subnets
resource "aws_subnet" "subnet" {
  vpc_id     = "${aws_vpc.vpc.id}"
  cidr_block = "10.0.1.0/24"

  tags {
    Name = "Main"
  }
}

# TODO: Add EIP for masters

