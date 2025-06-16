output "ec2_public_ip" {
value = aws_instance.ec2_1[0].public_ip
description = "public IP of the EC2 instance"
  
}