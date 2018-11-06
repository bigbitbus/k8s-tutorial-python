#
# VPC Resources
#  * VPC
#  * Subnets
#  * Internet Gateway
#  * Route Table
#

resource "aws_vpc" "kube" {
  cidr_block = "10.0.0.0/16"

  tags = "${
    map(
     "Name", "kubetutorial101-node",
     "kubernetes.io/cluster/${var.cluster-name}", "shared",
    )
  }"
}

resource "aws_subnet" "kube" {
  count = 2

  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
  cidr_block        = "10.0.${count.index}.0/24"
  vpc_id            = "${aws_vpc.kube.id}"

  tags = "${
    map(
     "Name", "kubetutorial101-node",
     "kubernetes.io/cluster/${var.cluster-name}", "shared",
    )
  }"
}

resource "aws_internet_gateway" "kube" {
  vpc_id = "${aws_vpc.kube.id}"

  tags {
    Name = "kubetutorial101"
  }
}

resource "aws_route_table" "kube" {
  vpc_id = "${aws_vpc.kube.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.kube.id}"
  }
}

resource "aws_route_table_association" "kube" {
  count = 2

  subnet_id      = "${aws_subnet.kube.*.id[count.index]}"
  route_table_id = "${aws_route_table.kube.id}"
}
