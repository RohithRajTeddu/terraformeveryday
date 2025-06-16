
# vpc creation
resource "aws_vpc" "VPC_rohith" {
  
  cidr_block = "10.0.0.0/16"
}


#subnet creation
resource "aws_subnet" "public" {
    vpc_id     = aws_vpc.VPC_rohith.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "ap-south-1"
    tags = {
        Name = "Public_Subnet"

    } 
}

resource "aws_subnet" "private" {
    vpc_id     = aws_vpc.VPC_rohith.id
    cidr_block = "10.0.2.0/24"
    availability_zone = "ap-south-1"
    tags = {
        Name = "Private_Subnet"

    } 
}

#internet gateway creation
resource "aws_internet_gateway" "Cust_IG" {
  vpc_id = aws_vpc.VPC_rohith.id
  tags = {
   Name = "custum_IG"
  }
}

# route table creation and edit routes
resource "aws_route_table" "cust_route" {
  vpc_id = aws_vpc.VPC_rohith.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.Cust_IG.id
  }
  tags = { 
    Name = "custum_route"
}
}


#subnet association with route table
resource "aws_route_table_association" "name" {
  subnet_id = aws_subnet.public.id
  route_table_id = aws_route_table.cust_route.id
}

#Create Security Group

resource "aws_security_group" "name" {
  name = "cust_SG"
  description = "allow all SSH users"
  vpc_id = aws_vpc.VPC_rohith.id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    }
}
#create elastic IP
resource "aws_eip" "elaastic_IP" {
    domain =  "vpc"
  
}

resource "aws_eip_association" "name" {
    instance_id   = aws_instance.private_ec2.id
    allocation_id = aws_eip.elaastic_IP.id
  
}

#create NAt gateway
resource "aws_nat_gateway" "cust_natgat" {
  allocation_id = aws_eip.elaastic_IP.id
  subnet_id = aws_subnet.private.id
  tags = {
    Name = "custum_Nat"
  }
  
}


#create ec2 instance private & Public
resource "aws_instance" "public_ec2" {
  ami = "ami-01376101673c89611"
  instance_type  = "t2.micro"
  vpc_security_group_ids = [aws_security_group.name.id]
  subnet_id = aws_subnet.public.id
  key_name = "mumbaikey1"
  tags = {
    Name = "public_ec2"
  }

}

resource "aws_instance" "private_ec2" {
  ami = "ami-01376101673c89611"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.name.id]
  subnet_id = aws_subnet.private.id
  key_name = "mumbaikey1"
   tags = {
    Name = "private_ec2"
  }
}