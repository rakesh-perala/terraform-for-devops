variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "AWS EC2 key pair name"
  type        = string
}

variable "public_key_path" {
  description = "Path to the public SSH key"
  type        = string
}

variable "security_group_name" {
  description = "Security group name"
  type        = string
  default     = "automate-sg"
}

variable "ssh_port" {
  description = "SSH port"
  type        = number
  default     = 22
}

variable "http_port" {
  description = "HTTP port"
  type        = number
  default     = 80
}

variable "root_volume_size" {
  description = "Root EBS volume size in GB"
  type        = number
  default     = 15
}

variable "root_volume_type" {
  description = "Root EBS volume type"
  type        = string
  default     = "gp3"
}

variable "instance_name" {
  description = "EC2 instance name"
  type        = string
  default     = "buildserver"
}

variable "security_group_tag" {
  description = "Security group Name tag"
  type        = string
  default     = "auto-sg"
}
