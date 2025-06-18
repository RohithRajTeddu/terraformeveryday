resource "aws_instance" "name" {
  ami = var.amiid
  instance_type = var.instancetype
}