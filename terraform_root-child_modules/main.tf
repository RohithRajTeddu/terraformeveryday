module "ec2_dev" {
  source = "./ec2_module"
  amiid = "ami-01376101673c89611"
  instancetype = "t2.micro"
  }