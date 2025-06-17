module "calling_instance_module" {
    source = "../instance_crearion"  #calling ec2 creation module from directory "instance_crearion"
    ami_id  = "ami-0b09627181c8d5778"
    instancetype = "t2.micro"
    nameofinstance = "dev_apple_instance"
  
}