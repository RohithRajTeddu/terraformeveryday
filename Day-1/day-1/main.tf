resource "aws_instance" "ec2_1" {
  ami = var.ami_id
  instance_type =var.instance_type
  count = var.instance_count
  tags = {
    Name = "ec2_developer"
  }
}
 