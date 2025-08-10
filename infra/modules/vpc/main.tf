resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr
  tags = { Name = var.name }
}

resource "aws_subnet" "public" {
  vpc_id = aws_vpc.this.id
  cidr_block = var.public_subnet_cidr
  map_public_ip_on_launch = true
  availability_zone = var.az
  tags = { Name = "${var.name}-public-subnet" }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.this.id
  tags = { Name = "${var.name}-igw" }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = { Name = "${var.name}-public-rt" }
}

resource "aws_route_table_association" "pub_assoc" {
  subnet_id = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}