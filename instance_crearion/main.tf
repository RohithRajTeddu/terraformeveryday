resource "aws_instance" "ec2_dev" {
  instance_type = var.instancetype
  ami           = var.ami_id
  tags = {
    name = var.nameofinstance
  }
}