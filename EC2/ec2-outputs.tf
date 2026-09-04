
# EC2 Instance ID


output "instance_id" {
  description = "EC2 instance ID"
  value       = aws_instance.my_instance.id
}



# EC2 Public IP


output "public_ip" {
  description = "Public IP address of EC2 instance"
  value       = aws_instance.my_instance.public_ip
}



# EC2 Public DNS


output "public_dns" {
  description = "Public DNS name of EC2 instance"
  value       = aws_instance.my_instance.public_dns
}



# EC2 Private IP


output "private_ip" {
  description = "Private IP address of EC2 instance"
  value       = aws_instance.my_instance.private_ip
}



# AMI ID


output "ami_id" {
  description = "Ubuntu AMI ID used by EC2"
  value       = data.aws_ami.ubuntu.id
}



# Security Group ID


output "security_group_id" {
  description = "Security group ID attached to EC2"
  value       = aws_security_group.my_security_group.id
}



# Key Pair Name


output "key_pair_name" {
  description = "EC2 key pair name"
  value       = aws_key_pair.my_key.key_name
}
