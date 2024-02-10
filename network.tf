
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr_block
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  tags = {
    Name = "my-vpc"
  }
}

resource "aws_subnet" "public_subnet" {
  count             = length(local.public_cidr_blocks)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = local.public_cidr_blocks[count.index]
  availability_zone = local.azs[count.index]

  tags = {
    Name = "public-subnet-${count.index}"
  }
}

resource "aws_subnet" "private_subnet" {
  count = length(local.private_cidr_blocks)

  vpc_id            = aws_vpc.vpc.id
  cidr_block        = local.private_cidr_blocks[count.index]
  availability_zone = local.azs[count.index]

  tags = {
    Name = "private-subnet-${count.index}"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "internet-gateway"
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-route-table"
  }
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "private-route-table"
  }
}

resource "aws_route_table_association" "public_route_association" {
  count = length(aws_subnet.public_subnet)

  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "private_route_association" {
  count = length(aws_subnet.private_subnet)

  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_iam_instance_profile" "profile" {
  name = "ec2_profile"
  role = aws_iam_role.ec2_csye6225_role.name
}
resource "aws_iam_role_policy_attachment" "cloudwatch_policy_attachment" {
  policy_arn = data.aws_iam_policy.cloud_watch_access.arn
  role       = aws_iam_role.ec2_csye6225_role.name
}

resource "aws_security_group" "instance" {
  name_prefix = "application-sg"
  vpc_id      = aws_vpc.vpc.id
  ingress {
    from_port       = local.ingress_port[0]
    to_port         = local.ingress_port[0]
    protocol        = "tcp"
    security_groups = [aws_security_group.loadbalancer_securitygroup.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

