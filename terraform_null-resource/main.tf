resource "aws_s3_bucket" "bucket1" {
    bucket = "teddu123"
}
resource "aws_s3_bucket_versioning" "name" {
    bucket = aws_s3_bucket.bucket1.id
    versioning_configuration {
      status = "Enabled"
    }
  
}



resource "aws_key_pair" "keypair1" {
    key_name   = "teddukey"
    public_key = file("~/.ssh/id_rsa.pub")
  
}

resource "aws_iam_role" "ec2_role" {
  name = "ec2-s3-access-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_policy" "s3_access" {
    name        = "s3-access-policy"
    description = "Policy for S3 access"
    policy = jsondecode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Action = [
        "s3:*"
      ],
      Resource = "*"
    }]
  })
  
}

resource "aws_iam_role_policy_attachment" "attach_policy" {
    role = aws_iam_role.ec2_role.name
    policy_arn = aws_iam_policy.s3_access.arn
  
}

resource "aws_iam_instance_profile" "instance_profile" {
    name = "ec2-s3-access-profile"
    role = aws_iam_role.ec2_role.name
  
}

resource "aws_instance" "dev_rohith" {
    ami = "ami-01376101673c89611"
    instance_type = "t2.micro"
    tags = {
      Name = rohith_developer
    }
    iam_instance_profile = aws_iam_instance_profile.instance_profile.name
  
}