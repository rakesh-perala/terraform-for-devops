data "aws_ami" "ubuntu" {

  most_recent = true

  owners = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}



# Key Pair


resource "aws_key_pair" "my_key" {
  key_name   = "rakesh-key-ec2"
  public_key = file("rakesh-key-ec2.pub")
}



# Default VPC


resource "aws_default_vpc" "default" {
}



# Security Group


resource "aws_security_group" "my_security_group" {
  name        = "automate-sg"
  description = "This will add Terraform generated SG"
  vpc_id      = aws_default_vpc.default.id

  
  # Inbound Rules
  

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH open"
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTP open"
  }

  
  # Outbound Rules
  

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "All access open outbound"
  }

  tags = {
    Name = "auto-sg"
  }
}



# EC2 Instance


resource "aws_instance" "my_instance" {

  ami           = data.aws_ami.ubuntu.id

  instance_type = "t2.micro"

  key_name = aws_key_pair.my_key.key_name

  vpc_security_group_ids = [
    aws_security_group.my_security_group.id
  ]

  root_block_device {
    volume_size = 15
    volume_type = "gp3"
  }

  tags = {
    Name = "buildserver"
  }
}
