resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "${var.project}-vpc-2"
  }
}

resource "aws_subnet" "public_subnet_1a" {
  vpc_id            = aws_vpc.main.id
  availability_zone = "${var.region}a"
  cidr_block        = cidrsubnet(aws_vpc.main.cidr_block, 8, 10)

  tags = {
    Name = "${var.project}-public-subnet-1a"
  }
}

resource "aws_subnet" "private_subnet_1a" {
  vpc_id            = aws_vpc.main.id
  availability_zone = "${var.region}a"
  cidr_block        = cidrsubnet(aws_vpc.main.cidr_block, 8, 20)

  tags = {
    Name = "${var.project}-private-subnet-1a"
  }
}

resource "aws_internet_gateway" "main_igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.project}-igw"
  }
}

resource "aws_route_table" "public_route" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main_igw.id
  }

  tags = {
    Name = "${var.project}-public-route"
  }
}

resource "aws_route_table_association" "routing_subnet_association" {
  route_table_id = aws_route_table.public_route.id
  subnet_id      = aws_subnet.public_subnet_1a.id
}