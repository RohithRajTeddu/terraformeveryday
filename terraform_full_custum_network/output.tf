output "private_ip" {
  value =  aws_instance.private_ec2
  description = "private ip of the private ec2 instance"
  sensitive = true
}

output "elasticip" {
    value = aws_eip.elaastic_IP
    description = "eelastic ip"
    sensitive = true
  
}