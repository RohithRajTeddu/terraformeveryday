resource "aws_vpc" "vpc_rds" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_db_instance" "rds_db" {
  allocated_storage =    10
  db_name           =    "cust_rds"
  engine            =    "mysql"
  engine_version    =    "8.0"
  instance_class    =    "db.t4g.micro"
  username          =    "admin"
  password          =    "rohith123"
  parameter_group_name = "default.mysql8.0"
  db_subnet_group_name = aws_db_subnet_group.subnetgroup.id
  vpc_security_group_ids = [aws_security_group.SG_rds.id]


  backup_retention_period = 7
  backup_window = "02:00-03:00"

depends_on = [ aws_security_group.SG_rds, ]
}


resource "aws_security_group" "SG_rds" {
  name = "rds-sg"
  description = "RDS Security Group"
  vpc_id = aws_vpc.vpc_rds.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  depends_on = [ aws_vpc.vpc_rds ]
}

resource "aws_subnet" "subnet1" {
    vpc_id = aws_vpc.vpc_rds.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "ap-south-1a"
  depends_on = [ aws_vpc.vpc_rds ]
}

resource "aws_subnet" "subnet2" {
    vpc_id = aws_vpc.vpc_rds.id
    cidr_block = "10.0.2.0/24"
    availability_zone = "ap-south-1b"
    depends_on = [ aws_vpc.vpc_rds ]
  
}

resource "aws_db_subnet_group" "subnetgroup" {
    subnet_ids = [ aws_subnet.subnet1.id,aws_subnet.subnet2.id ]
  
}

######################              Read Replica           #################################

resource "aws_vpc" "vpc_rr" {
  cidr_block = "10.0.0.0/16"
  provider = aws.for_secondary_readReplica
}


resource "aws_subnet" "subnet1_rr" {
    provider = aws.for_secondary_readReplica
    vpc_id = aws_vpc.vpc_rr.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "us-east-1a"

  depends_on = [ aws_vpc.vpc_rr ]
  
}

resource "aws_subnet" "subnet2_rr" {
    provider = aws.for_secondary_readReplica
    vpc_id = aws_vpc.vpc_rr.id
    cidr_block = "10.0.2.0/24"
    availability_zone = "us-east-1b"

    depends_on = [ aws_vpc.vpc_rr ]
  
}


resource "aws_security_group" "SG_rds_rr" {
  provider = aws.for_secondary_readReplica
  name = "rds-sg-rr"
  description = "RDS Security Group"
  vpc_id = aws_vpc.vpc_rr.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  depends_on = [ aws_vpc.vpc_rr ]
}

resource "aws_db_subnet_group" "subnet_group_rr" {
   provider = aws.for_secondary_readReplica
    name       = "rds-subnet-group-rr"
    subnet_ids = [ aws_subnet.subnet1_rr.id,aws_subnet.subnet2_rr.id  ]
  
}


resource "aws_db_instance" "read_replica" {
  provider = aws.for_secondary_readReplica
  replicate_source_db = aws_db_instance.rds_db.arn
  instance_class = "db.t4g.micro"
  identifier = "database-replica"
  depends_on = [ aws_security_group.SG_rds ]
}