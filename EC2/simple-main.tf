
# Ubuntu AMI


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

  key_name   = var.key_name
  public_key = file(var.public_key_path)
}



# Default VPC


resource "aws_default_vpc" "default" {
}



# Security Group


resource "aws_security_group" "my_security_group" {

  name        = var.security_group_name
  description = "This will add Terraform generated SG"

  vpc_id = aws_default_vpc.default.id

  
  # Inbound rules SSH
  

  ingress {

    from_port   = var.ssh_port
    to_port     = var.ssh_port
    protocol    = "tcp"

    cidr_blocks = ["0.0.0.0/0"]

    description = "SSH open"
  }


  
  #  Inbound rules HTTP
  

  ingress {

    from_port   = var.http_port
    to_port     = var.http_port
    protocol    = "tcp"

    cidr_blocks = ["0.0.0.0/0"]

    description = "HTTP open"
  }


  
  # Outbound egress
  

  egress {

    from_port   = 0
    to_port     = 0
    protocol    = "-1"

    cidr_blocks = ["0.0.0.0/0"]

    description = "All access open outbound"
  }


  tags = {

    Name = var.security_group_tag
  }
}



# EC2 Instance

resource "aws_instance" "my_instance" {

  ami = data.aws_ami.ubuntu.id

  instance_type = var.instance_type

  key_name = aws_key_pair.my_key.key_name


  # Security Group

  vpc_security_group_ids = [
    aws_security_group.my_security_group.id
  ]


  # Root EBS Volume

  root_block_device {

    volume_size = var.root_volume_size

    volume_type = var.root_volume_type
  }


  # Tags

  tags = {

    Name = var.instance_name
  }
}
