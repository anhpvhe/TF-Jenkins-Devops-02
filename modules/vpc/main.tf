# create vpc
resource "aws_vpc" "vpc" {
  cidr_block              = var.vpc_cidr
  instance_tenancy        = "default"
  enable_dns_hostnames    = true

  tags      = {
    Name    = "${var.project_name}-vpc"
  }
}

# create internet gateway and attach it to vpc
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id    = aws_vpc.vpc.id

  tags      = {
    Name    = "${var.project_name}-igw"
  }
}

# use data source to get all avalablility zones in region
data "aws_availability_zones" "available_zones" {}

# create public subnet az1
resource "aws_subnet" "public_subnet_az1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnet_az1_cidr
  availability_zone       = data.aws_availability_zones.available_zones.names[0]
  map_public_ip_on_launch = true

  tags      = {
    Name    = "public subnet az1"
  }
}

# create public subnet az2
resource "aws_subnet" "public_subnet_az2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnet_az2_cidr
  availability_zone       = data.aws_availability_zones.available_zones.names[1]
  map_public_ip_on_launch = true

  tags      = {
    Name    = "public subnet az2"
  }
}

# create route table and add public route
resource "aws_route_table" "public_route_table" {
  vpc_id       = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags       = {
    Name     = "Public route table"
  }
}

# associate public subnet az1 to "public route table"
resource "aws_route_table_association" "public_subnet_az1_route_table_association" {
  subnet_id           = aws_subnet.public_subnet_az1.id
  route_table_id      = aws_route_table.public_route_table.id
}

# associate public subnet az2 to "public route table"
resource "aws_route_table_association" "public_subnet_az2_route_table_association" {
  subnet_id           = aws_subnet.public_subnet_az2.id
  route_table_id      = aws_route_table.public_route_table.id
}

# create private app subnet az1
resource "aws_subnet" "private_app_subnet_az1" {
  vpc_id                   = aws_vpc.vpc.id
  cidr_block               = var.private_subnet_az1_cidr
  availability_zone        = data.aws_availability_zones.available_zones.names[0]
  map_public_ip_on_launch  = false

  tags      = {
    Name    = "private app subnet az1"
  }
}

# create private app subnet az2
resource "aws_subnet" "private_app_subnet_az2" {
  vpc_id                   = aws_vpc.vpc.id
  cidr_block               = var.private_subnet_az2_cidr
  availability_zone        = data.aws_availability_zones.available_zones.names[1]
  map_public_ip_on_launch  = false

  tags      = {
    Name    = "private app subnet az2"
  }
}

# create private data subnet az1
resource "aws_subnet" "private_data_subnet_az1" {
  vpc_id                   = aws_vpc.vpc.id
  cidr_block               = var.private_data_subnet_az1_cidr
  availability_zone        = data.aws_availability_zones.available_zones.names[0]
  map_public_ip_on_launch  = false

  tags      = {
    Name    = "private data subnet az1"
  }
}

# create private data subnet az2
resource "aws_subnet" "private_data_subnet_az2" {
  vpc_id                   = aws_vpc.vpc.id
  cidr_block               = var.private_data_subnet_az2_cidr
  availability_zone        = data.aws_availability_zones.available_zones.names[1]
  map_public_ip_on_launch  = false

  tags      = {
    Name    = "private data subnet az2"
  }
}

module "nat_gateway" {
  source                     = "../nat-gateway"
  vpc_id                     = aws_vpc.vpc.id
  internet_gateway           = aws_internet_gateway.internet_gateway
  public_subnet_az1_id       = aws_subnet.public_subnet_az1.id
  public_subnet_az2_id       = aws_subnet.public_subnet_az2.id
  private_app_subnet_az1_id  = aws_subnet.private_app_subnet_az1.id
  private_app_subnet_az2_id  = aws_subnet.private_app_subnet_az2.id
  private_data_subnet_az1_id = aws_subnet.private_data_subnet_az1.id
  private_data_subnet_az2_id = aws_subnet.private_data_subnet_az2.id
}


# resource "aws_route_table" "private_route_table" {
#   vpc_id = aws_vpc.vpc.id

#   route {
#     cidr_block     = "0.0.0.0/0"
#     nat_gateway_id = module.nat_gateway.nat_gateway_az1_id
#   }
#   route {
#     cidr_block     = "0.0.0.0/0"
#     nat_gateway_id = module.nat_gateway.nat_gateway_az2_id
#   }

#   tags = {
#     Name = "private_route_table"
#   }
# }


# # associate private app subnet az1 with private route table az1
# resource "aws_route_table_association" "private_app_subnet_az1_route_table_association" {
#   subnet_id      = aws_subnet.private_app_subnet_az1.id
#   route_table_id = aws_route_table.private_route_table.id
# }

# # associate private data subnet az1 with private route table az1
# resource "aws_route_table_association" "private_data_subnet_az1_route_table_association" {
#   subnet_id      = aws_subnet.private_data_subnet_az1.id
#   route_table_id = aws_route_table.private_route_table.id
# }

# # associate private app subnet az2 with private route table az2
# resource "aws_route_table_association" "private_app_subnet_az2_route_table_association" {
#   subnet_id      = aws_subnet.private_app_subnet_az2.id
#   route_table_id = aws_route_table.private_route_table.id
# }

# # associate private data subnet az2 with private route table az2
# resource "aws_route_table_association" "private_data_subnet_az2_route_table_association" {
#   subnet_id      = aws_subnet.private_data_subnet_az2.id
#   route_table_id = aws_route_table.private_route_table.id
# }