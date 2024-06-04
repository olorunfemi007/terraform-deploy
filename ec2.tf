provider "aws" {
  region = "us-east-2"
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "public" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.0.0/24"
  map_public_ip_on_launch = true
  availability_zone = "us-east-2a"
}

resource "aws_subnet" "private" {
  count = 4
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.${count.index + 2}.0/24"
  availability_zone = element(["us-east-2a", "us-east-2b", "us-east-2c"], count.index)
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table_association" "public" {
  subnet_id = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route" "public_internet_access" {
  route_table_id = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.main.id
}

# resource "aws_eip" "nat_eip" {
#   vpc = true
# }

# resource "aws_nat_gateway" "nat_gateway" {
#   allocation_id = aws_eip.nat_eip.id
#   subnet_id     = aws_subnet.public.id
# }

# # Create a route table for the private subnet
# resource "aws_route_table" "private_route_table" {
#   vpc_id = aws_vpc.main.id

#   route {
#     cidr_block = "0.0.0.0/0"
#     nat_gateway_id = aws_nat_gateway.nat_gateway.id
#   }
# }

# # Associate the private route table with the private subnet
# resource "aws_route_table_association" "private_subnet_association" {
#   count = 4
#   subnet_id      = element(aws_subnet.private.*.id, count.index)
#   route_table_id = aws_route_table.private_route_table.id
# }


resource "aws_instance" "public_instance" {
  ami = var.ami
  key_name = "vpc"
  instance_type = var.instance_type[3]
  subnet_id = aws_subnet.public.id
  user_data = file("${path.module}/jenkins.sh")
  vpc_security_group_ids  = [aws_security_group.public_sg.id]
  tags = {
    Name = "jumpserver"
  }
}

resource "aws_instance" "private_instance" {
  ami = var.ami
  count = 4
  key_name = "vpc"
  instance_type = var.instance_type[1]
  subnet_id = element(aws_subnet.private.*.id, count.index)
  vpc_security_group_ids = [aws_security_group.private_sg.id] 
  tags = {
    Name = "PrivateInstance${count.index + 1}"
  }
}
# resource "aws_instance" "ec2" {
#   ami           = var.ami
#   instance_type = "t2.micro"
#   key_name      = "vpc"
#   user_data     = file("${path.module}/httpd.sh")
#   tags = {
#     Name = "terraform-ec2"
#   }

# }


