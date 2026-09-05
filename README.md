# 🚀 Terraform – Complete Enterprise DevOps Guide

> **Terraform Modules + Remote Backend + State Management + Import + Drift + CI/CD + AWS VPC + EKS + Enterprise Project Structure**

---

# 📚 Table of Contents

1. [What is Terraform?](#1-what-is-terraform)
2. [Why Do We Use Terraform?](#2-why-do-we-use-terraform)
3. [Terraform Architecture](#3-terraform-architecture)
4. [Terraform Workflow](#4-terraform-workflow)
5. [Terraform Project Structure](#5-terraform-project-structure)
6. [Terraform Core Concepts](#6-terraform-core-concepts)
7. [Terraform Providers](#7-terraform-providers)
8. [Resources](#8-resources)
9. [Data Sources](#9-data-sources)
10. [Variables](#10-variables)
11. [Locals](#11-locals)
12. [Outputs](#12-outputs)
13. [Terraform Modules](#13-terraform-modules)
14. [Module Inputs and Outputs](#14-module-inputs-and-outputs)
15. [Module `for_each`](#15-module-foreach)
16. [Module Versioning](#16-module-versioning)
17. [Terraform State File](#17-terraform-state-file)
18. [Local State](#18-local-state)
19. [Remote Backend](#19-remote-backend)
20. [AWS S3 Remote Backend](#20-aws-s3-remote-backend)
21. [State Locking](#21-state-locking)
22. [State Management Commands](#22-state-management-commands)
23. [State Migration](#23-state-migration)
24. [Terraform Import](#24-terraform-import)
25. [Import Blocks](#25-import-blocks)
26. [Terraform Drift](#26-terraform-drift)
27. [Refresh-Only Operations](#27-refresh-only-operations)
28. [Count vs For Each](#28-count-vs-for-each)
29. [Count to For Each Migration](#29-count-to-for-each-migration)
30. [Terraform Workspaces](#30-terraform-workspaces)
31. [Terraform Lifecycle](#31-terraform-lifecycle)
32. [Terraform Depends On](#32-terraform-depends-on)
33. [Terraform Provisioners](#33-terraform-provisioners)
34. [Terraform Provider Lock File](#34-terraform-provider-lock-file)
35. [Terraform AWS VPC](#35-terraform-aws-vpc)
36. [VPC Architecture](#36-vpc-architecture)
37. [Public and Private Subnets](#37-public-and-private-subnets)
38. [Internet Gateway](#38-internet-gateway)
39. [NAT Gateway](#39-nat-gateway)
40. [Route Tables](#40-route-tables)
41. [Security Groups](#41-security-groups)
42. [Terraform EKS](#42-terraform-eks)
43. [EKS Architecture](#43-eks-architecture)
44. [EKS Networking](#44-eks-networking)
45. [EKS Node Groups](#45-eks-node-groups)
46. [EKS IAM](#46-eks-iam)
47. [EKS Add-ons](#47-eks-add-ons)
48. [Terraform CI/CD with Jenkins](#48-terraform-cicd-with-jenkins)
49. [Enterprise Terraform CI/CD](#49-enterprise-terraform-cicd)
50. [Terraform Security](#50-terraform-security)
51. [Enterprise Project Structure](#51-enterprise-project-structure)
52. [Environment Separation](#52-environment-separation)
53. [State Isolation](#53-state-isolation)
54. [Terraform Enterprise Workflow](#54-terraform-enterprise-workflow)
55. [Troubleshooting](#55-troubleshooting)
56. [State Recovery](#56-state-recovery)
57. [Production Best Practices](#57-production-best-practices)
58. [Terraform Interview Questions](#58-terraform-interview-questions)
59. [Quick Revision Cheat Sheet](#59-quick-revision-cheat-sheet)

---

# 1. What is Terraform?

Terraform is an **Infrastructure as Code (IaC)** tool used to create, modify and manage infrastructure using configuration files.

Instead of manually creating:

```text
VPC
EC2
Security Groups
ALB
RDS
EKS
S3
IAM
```

from the AWS Console, we define infrastructure using Terraform code.

Example:

```hcl
resource "aws_instance" "web" {
  ami           = "ami-xxxxxxxx"
  instance_type = "t2.micro"
}
```

Terraform creates the EC2 instance.

---

# 2. Why Do We Use Terraform?

Without Terraform:

```text
Developer
   ↓
AWS Console
   ↓
Manually create resources
```

Problems:

* Manual errors
* Difficult to reproduce
* Difficult to maintain
* No proper version control
* Configuration differences between environments

With Terraform:

```text
Git
 ↓
Terraform
 ↓
AWS
```

Benefits:

* Infrastructure as Code
* Version control
* Automation
* Repeatability
* Reusability
* Consistency
* Review through Pull Requests
* CI/CD integration
* Disaster recovery

---

# 3. Terraform Architecture

```text
                  Developer
                      |
                      v
                Git Repository
                      |
                      v
              Terraform Configuration
                      |
                      v
                Terraform CLI
                      |
          +-----------+-----------+
          |                       |
          v                       v
      Terraform State         Providers
          |                       |
          v                       v
     Remote Backend              AWS
          |              +--------+--------+
          |              |        |        |
          |             VPC      EC2      EKS
          |                       |
          +-----------------------+
```

---

# 4. Terraform Workflow

The standard Terraform workflow is:

```text
terraform init
       ↓
terraform fmt
       ↓
terraform validate
       ↓
terraform plan
       ↓
terraform apply
       ↓
Infrastructure
```

Destroy:

```text
terraform destroy
```

---

# 5. Terraform Project Structure

Simple project:

```text
terraform-project/
├── main.tf
├── variables.tf
├── outputs.tf
├── terraform.tfvars
├── providers.tf
├── versions.tf
├── backend.tf
└── README.md
```

Enterprise project:

```text
terraform-aws/
│
├── modules/
│   ├── vpc/
│   ├── security-group/
│   ├── ec2/
│   ├── alb/
│   ├── rds/
│   └── eks/
│
├── environments/
│   ├── dev/
│   ├── qa/
│   └── prod/
│
├── scripts/
│
├── .gitignore
├── .terraform.lock.hcl
└── README.md
```

---

# 6. Terraform Core Concepts

Terraform has several important building blocks:

```text
Provider
   ↓
Resource
   ↓
Variables
   ↓
Data Sources
   ↓
Modules
   ↓
State
   ↓
Backend
   ↓
Outputs
```

Important concepts:

| Concept     | Purpose                             |
| ----------- | ----------------------------------- |
| Provider    | Connects Terraform to AWS/Azure/GCP |
| Resource    | Creates infrastructure              |
| Data Source | Reads existing infrastructure       |
| Variable    | Input value                         |
| Local       | Calculated/reusable value           |
| Output      | Exposes information                 |
| Module      | Reusable Terraform code             |
| State       | Tracks managed infrastructure       |
| Backend     | Stores state                        |
| Lifecycle   | Controls resource behavior          |

---

# 7. Terraform Providers

A provider allows Terraform to communicate with an external platform.

Example AWS provider:

```hcl
provider "aws" {
  region = "ap-south-1"
}
```

Terraform can then communicate with AWS.

---

# 8. Resources

Resources create infrastructure.

Example:

```hcl
resource "aws_instance" "web" {
  ami           = "ami-xxxxxxxx"
  instance_type = "t2.micro"
}
```

Terraform resource address:

```text
aws_instance.web
```

---

# 9. Data Sources

A data source reads existing information.

Example:

```hcl
data "aws_ami" "ubuntu" {
  most_recent = true

  owners = ["099720109477"]

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}
```

Then:

```hcl
ami = data.aws_ami.ubuntu.id
```

### Resource vs Data Source

```text
Resource
   ↓
Create/manage infrastructure

Data Source
   ↓
Read existing information
```

---

# 10. Variables

Variables allow us to avoid hardcoding values.

```hcl
variable "instance_type" {
  type    = string
  default = "t2.micro"
}
```

Use:

```hcl
instance_type = var.instance_type
```

---

# 11. Locals

Locals store calculated or reusable values.

```hcl
locals {
  environment = "dev"

  common_tags = {
    Environment = local.environment
    ManagedBy   = "Terraform"
  }
}
```

Use:

```hcl
tags = local.common_tags
```

---

# 12. Outputs

Outputs expose useful information.

```hcl
output "instance_public_ip" {
  value = aws_instance.web.public_ip
}
```

Run:

```bash
terraform output
```

---

# 13. Terraform Modules

A Terraform module is a **reusable collection of Terraform configuration files**.

Instead of copying EC2 code into:

```text
dev
qa
prod
```

we create:

```text
modules/ec2/
```

and reuse it.

Architecture:

```text
                 EC2 MODULE
                     |
          +----------+----------+
          |          |          |
         DEV         QA        PROD
```

---

# 14. Module Inputs and Outputs

Module:

```text
modules/ec2/
├── main.tf
├── variables.tf
└── outputs.tf
```

### Child module

```hcl
resource "aws_instance" "this" {
  ami           = var.ami_id
  instance_type = var.instance_type

  tags = {
    Name = var.instance_name
  }
}
```

Variables:

```hcl
variable "ami_id" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "instance_name" {
  type = string
}
```

Output:

```hcl
output "public_ip" {
  value = aws_instance.this.public_ip
}
```

### Root module

```hcl
module "web" {
  source = "./modules/ec2"

  ami_id        = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  instance_name = "web-server"
}
```

Access output:

```hcl
module.web.public_ip
```

---

# 15. Module `for_each`

We can create multiple module instances.

```hcl
variable "servers" {
  type = map(object({
    instance_type = string
    name          = string
  }))
}
```

Example:

```hcl
servers = {
  web = {
    instance_type = "t2.micro"
    name          = "web-server"
  }

  app = {
    instance_type = "t2.small"
    name          = "app-server"
  }
}
```

Module:

```hcl
module "ec2" {
  for_each = var.servers

  source = "./modules/ec2"

  ami_id        = data.aws_ami.ubuntu.id
  instance_type = each.value.instance_type
  instance_name = each.value.name
}
```

Resources become:

```text
module.ec2["web"]
module.ec2["app"]
```

---

# 16. Module Versioning

For shared modules, versioning is important.

Example:

```text
EC2 Module

v1.0
v1.1
v2.0
```

Production should not unexpectedly receive untested module changes.

For registry modules:

```hcl
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "..."
}
```

Enterprise approach:

```text
Development
    ↓
Test new module version
    ↓
QA
    ↓
Validate
    ↓
Production
```

---

# 17. Terraform State File

This is one of the **most important Terraform topics**.

Terraform state stores Terraform's knowledge about resources it manages.

Default local state:

```text
terraform.tfstate
```

Example:

```text
Terraform Configuration
        |
        v
aws_instance.web
        |
        v
Terraform State
        |
        v
EC2 Instance
```

State contains information such as:

* Resource IDs
* Attributes
* Provider information
* Dependencies
* Resource addresses
* Metadata

---

# 18. Local State

By default Terraform stores state locally.

```text
terraform.tfstate
```

Example:

```text
project/
├── main.tf
├── variables.tf
├── outputs.tf
└── terraform.tfstate
```

### Problem with local state

For a team:

```text
Developer A → local state
Developer B → different local state
Developer C → different local state
```

This can cause problems.

Therefore teams normally use a **remote backend**.

---

# 19. Remote Backend

A backend controls where Terraform stores its state.

Instead of:

```text
Developer Laptop
      ↓
terraform.tfstate
```

we use:

```text
Terraform
    ↓
Remote Backend
    ↓
S3
```

Advantages:

* Centralized state
* Team collaboration
* State locking
* Encryption
* Versioning
* Backup/recovery
* Controlled access

---

# 20. AWS S3 Remote Backend

A common enterprise pattern is:

```text
Terraform
    |
    v
S3 Bucket
    |
    ├── dev/network/terraform.tfstate
    ├── dev/compute/terraform.tfstate
    ├── qa/network/terraform.tfstate
    ├── qa/compute/terraform.tfstate
    ├── prod/network/terraform.tfstate
    └── prod/compute/terraform.tfstate
```

Example backend:

```hcl
terraform {
  backend "s3" {
    bucket       = "company-terraform-state"
    key          = "dev/ec2/terraform.tfstate"
    region       = "ap-south-1"
    encrypt      = true
    use_lockfile = true
  }
}
```

Important:

The S3 bucket should already exist before Terraform uses it as the backend.

Usually the backend bucket is created through a separate bootstrap process.

---

# 21. State Locking

State locking prevents multiple Terraform operations from modifying the same state simultaneously.

Example:

```text
Jenkins Job A
     |
     ↓
Terraform Apply
     |
     ↓
State LOCKED
     
Jenkins Job B
     |
     ↓
Terraform Apply
     |
     ↓
WAIT / FAIL
```

This protects against concurrent state updates.

Modern S3 backend configurations can use:

```hcl
use_lockfile = true
```

Older enterprise setups may use DynamoDB-based locking. If maintaining an older setup, understand its locking configuration before changing it.

### Important

State locking is not an AWS infrastructure lock.

It protects the **Terraform state operation**.

---

# 22. State Management Commands

List resources:

```bash
terraform state list
```

Example:

```text
aws_instance.web
aws_security_group.web
aws_vpc.main
```

Show resource:

```bash
terraform state show aws_instance.web
```

Move resource:

```bash
terraform state mv old.address new.address
```

Remove from state:

```bash
terraform state rm aws_instance.web
```

Pull state:

```bash
terraform state pull
```

Backup:

```bash
terraform state pull > state-backup.json
```

Push state:

```bash
terraform state push state.json
```

> ⚠️ `terraform state push` is dangerous. Use it only for controlled recovery after validating the state.

---

# 23. State Migration

Suppose initially:

```text
Local State
terraform.tfstate
```

Later the team wants:

```text
S3 Remote State
```

Configure the backend and run:

```bash
terraform init -migrate-state
```

Terraform asks whether to migrate the existing state.

### Important commands

```bash
terraform init -migrate-state
```

Migrates existing state.

```bash
terraform init -reconfigure
```

Reinitializes backend configuration without migrating existing state.

---

# 24. Terraform Import

Sometimes infrastructure already exists.

Example:

```text
AWS Console
     ↓
EC2 already exists
```

But Terraform doesn't manage it.

We can import it.

Example:

```hcl
resource "aws_instance" "web" {
  ami           = "ami-xxxxxxxx"
  instance_type = "t2.micro"
}
```

Then:

```bash
terraform import aws_instance.web i-0123456789abcdef0
```

Terraform now knows:

```text
aws_instance.web
        ↓
i-0123456789abcdef0
```

### Important

Import primarily brings the existing object into **Terraform state**.

You still need appropriate Terraform configuration that matches the real infrastructure.

Always run:

```bash
terraform plan
```

after import.

---

# 25. Import Blocks

Modern Terraform also supports declarative import blocks.

Example:

```hcl
import {
  to = aws_instance.web
  id = "i-0123456789abcdef0"
}
```

Then:

```bash
terraform plan
```

and:

```bash
terraform apply
```

This makes imports easier to review through Git and CI/CD.

For supported resources and workflows, Terraform can also help generate configuration:

```bash
terraform plan -generate-config-out=generated.tf
```

Always review generated configuration before using it in production.

---

# 26. Terraform Drift

**Drift means the real infrastructure has changed outside Terraform.**

Example:

Terraform configuration:

```hcl
instance_type = "t2.micro"
```

AWS:

```text
t2.micro
```

Someone manually changes EC2:

```text
t2.micro
     ↓
t3.small
```

Now:

```text
Terraform Configuration
        |
        | t2.micro
        ↓
Terraform State
        |
        | t2.micro
        ↓
AWS
        |
        | t3.small
        ↓
DRIFT
```

Terraform can detect this difference during refresh/planning.

Run:

```bash
terraform plan
```

Terraform may propose changing the EC2 instance back to the configuration-defined value.

---

# 27. Refresh-Only Operations

Terraform can reconcile its state information with remote infrastructure without intentionally changing infrastructure.

Check:

```bash
terraform plan -refresh-only
```

Apply state-only refresh:

```bash
terraform apply -refresh-only
```

### Important

Older documentation may mention:

```bash
terraform refresh
```

The modern approach is to use:

```bash
terraform plan -refresh-only
```

or:

```bash
terraform apply -refresh-only
```

---

# 28. Count vs For Each

## Count

```hcl
resource "aws_instance" "web" {
  count = 2

  instance_type = "t2.micro"
}
```

Addresses:

```text
aws_instance.web[0]
aws_instance.web[1]
```

Problem:

Indexes can shift when the list changes.

---

## For Each

```hcl
resource "aws_instance" "web" {
  for_each = {
    web1 = "t2.micro"
    web2 = "t2.small"
  }

  instance_type = each.value
}
```

Addresses:

```text
aws_instance.web["web1"]
aws_instance.web["web2"]
```

### Enterprise recommendation

For named resources, `for_each` is often easier to manage because the keys represent stable identities.

---

# 29. Count to For Each Migration

Suppose we originally have:

```hcl
resource "aws_instance" "web" {
  count = 2
}
```

Addresses:

```text
aws_instance.web[0]
aws_instance.web[1]
```

Now we want:

```hcl
resource "aws_instance" "web" {
  for_each = {
    web1 = ...
    web2 = ...
  }
}
```

Addresses become:

```text
aws_instance.web["web1"]
aws_instance.web["web2"]
```

Do not simply change the code and blindly apply.

Terraform could interpret the address changes as replacements.

Use `moved` blocks:

```hcl
moved {
  from = aws_instance.web[0]
  to   = aws_instance.web["web1"]
}

moved {
  from = aws_instance.web[1]
  to   = aws_instance.web["web2"]
}
```

Then:

```bash
terraform plan
```

Terraform can understand that the resource identity was moved rather than recreated.

Alternative:

```bash
terraform state mv \
  'aws_instance.web[0]' \
  'aws_instance.web["web1"]'
```

---

# 30. Terraform Workspaces

Workspaces allow multiple Terraform state instances to use the same configuration.

Commands:

```bash
terraform workspace list
```

Create:

```bash
terraform workspace new dev
```

Select:

```bash
terraform workspace select dev
```

Show:

```bash
terraform workspace show
```

### Important enterprise point

Workspaces are useful, but don't automatically provide strong environment isolation.

For critical production environments, separate configurations/state boundaries and, where appropriate, separate AWS accounts are often clearer and safer.

---

# 31. Terraform Lifecycle

Terraform lifecycle controls how resources are created, updated and destroyed.

## create_before_destroy

```hcl
lifecycle {
  create_before_destroy = true
}
```

Terraform tries to create the replacement before destroying the old resource when the resource/provider behavior allows it.

Useful for reducing downtime.

---

## prevent_destroy

```hcl
lifecycle {
  prevent_destroy = true
}
```

Terraform prevents accidental destruction.

Useful for important resources such as:

```text
Production RDS
Production databases
Critical infrastructure
```

---

## ignore_changes

```hcl
lifecycle {
  ignore_changes = [
    tags
  ]
}
```

Terraform ignores changes to the specified attribute.

Use carefully.

Do not use `ignore_changes` just to hide unwanted drift.

---

# 32. Terraform Depends On

Terraform normally builds dependencies automatically.

Example:

```hcl
subnet_id = module.vpc.public_subnet_id
```

Terraform understands:

```text
VPC
 ↓
Subnet
 ↓
EC2
```

Explicit dependency:

```hcl
depends_on = [
  module.vpc
]
```

Use `depends_on` only when Terraform cannot infer the dependency automatically.

---

# 33. Terraform Provisioners

Provisioners allow commands to run during resource creation or destruction.

Example:

```hcl
provisioner "local-exec" {
  command = "echo Server created"
}
```

Provisioners are generally **not the first choice** for application configuration.

Prefer:

```text
Cloud-init
User Data
Ansible
Configuration Management
AWS Systems Manager
Container images
CI/CD
```

For example, installing Nginx:

```bash
#!/bin/bash

apt update -y
apt install nginx -y
systemctl enable nginx
systemctl start nginx
```

can be supplied through EC2 user data instead of relying on a provisioner.

---

# 34. Terraform Provider Lock File

Terraform creates:

```text
.terraform.lock.hcl
```

This records provider selections/checksums.

Normally:

```text
.terraform.lock.hcl
```

should be committed to Git.

Do not confuse it with:

```text
.terraform/
```

The `.terraform/` directory normally should not be committed.

---

# 35. Terraform AWS VPC

VPC is one of the most important AWS Terraform practicals.

Typical architecture:

```text
                    VPC
                10.0.0.0/16
                     |
       +-------------+-------------+
       |                           |
       ↓                           ↓
 Public Subnets              Private Subnets
       |                           |
       ↓                           ↓
    Internet                    NAT
    Gateway                     Gateway
       |                           |
       ↓                           ↓
      ALB                       EC2/EKS
```

---

# 36. VPC Architecture

Enterprise-style:

```text
                       AWS REGION
                           |
                           v
                     VPC 10.0.0.0/16
                           |
          +----------------+----------------+
          |                                 |
          v                                 v
    Availability Zone A              Availability Zone B
          |                                 |
    +-----+------+                    +-----+------+
    |            |                    |            |
    v            v                    v            v
 Public-A     Private-A            Public-B     Private-B
    |            |                    |            |
    |            +------ NAT ---------+            |
    |                                             |
    +--------------- Internet --------------------+
```

For production, use multiple Availability Zones for high availability.

---

# 37. Public and Private Subnets

Public subnet:

```text
Route Table
     ↓
Internet Gateway
```

Private subnet:

```text
Route Table
     ↓
NAT Gateway
     ↓
Internet Gateway
```

Typical usage:

### Public

```text
ALB
Bastion (if required)
Public-facing resources
```

### Private

```text
EC2
EKS nodes
Application servers
RDS
```

---

# 38. Internet Gateway

Internet Gateway provides internet connectivity for resources in public subnets when routing and public addressing are configured appropriately.

Terraform:

```hcl
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
}
```

---

# 39. NAT Gateway

NAT Gateway allows resources in private subnets to initiate outbound internet connections without making those resources directly internet-reachable.

Architecture:

```text
Private EC2
    |
    v
NAT Gateway
    |
    v
Internet Gateway
    |
    v
Internet
```

Production consideration:

NAT Gateway is typically deployed per AZ when high availability and AZ-failure isolation are required.

---

# 40. Route Tables

Public route:

```text
0.0.0.0/0
     ↓
Internet Gateway
```

Private route:

```text
0.0.0.0/0
     ↓
NAT Gateway
```

Terraform example:

```hcl
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
}
```

---

# 41. Security Groups

Security Groups act as virtual firewalls.

Example:

```hcl
resource "aws_security_group" "web" {
  name   = "web-sg"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
```

### Production best practice

Avoid:

```text
SSH 22 → 0.0.0.0/0
```

whenever possible.

Prefer:

```text
SSM
VPN
Bastion
Corporate CIDR
```

for administrative access.

---

# 42. Terraform EKS

EKS = **Amazon Elastic Kubernetes Service**.

Terraform can provision:

```text
VPC
Subnets
IAM
EKS Cluster
Node Groups
Security Groups
Add-ons
```

Architecture:

```text
                    Terraform
                       |
                       v
                     AWS
                       |
            +----------+----------+
            |                     |
            v                     v
           VPC                  IAM
            |
            v
        EKS Cluster
            |
      +-----+-----+
      |           |
      v           v
 Control Plane  Node Groups
                    |
             +------+------+
             |             |
             v             v
           Node          Node
             |
             v
          Pods
```

---

# 43. EKS Architecture

Typical enterprise setup:

```text
                    Internet
                       |
                       v
                      ALB
                       |
                       v
               EKS Kubernetes
                       |
          +------------+------------+
          |                         |
          v                         v
      Private Subnet A          Private Subnet B
          |                         |
       Worker                    Worker
       Node                       Node
          |                         |
          +------------+------------+
                       |
                      Pods
```

The EKS control plane is AWS-managed.

Your Terraform configuration manages the cluster resources and related AWS infrastructure.

---

# 44. EKS Networking

A common pattern:

```text
Public Subnets
    |
    └── Load Balancer

Private Subnets
    |
    └── EKS Nodes
          |
          └── Pods
```

Benefits:

* Reduced direct exposure
* Better network separation
* Better production architecture

---

# 45. EKS Node Groups

Example concept:

```text
EKS Cluster
    |
    +-- Managed Node Group
            |
            +-- Node 1
            +-- Node 2
            +-- Node 3
```

Terraform example using an EKS module could define:

```hcl
eks_managed_node_groups = {
  application = {
    instance_types = ["t3.medium"]

    min_size     = 2
    max_size     = 5
    desired_size = 2
  }
}
```

Exact module arguments depend on the module version being used.

---

# 46. EKS IAM

EKS requires IAM integration for AWS permissions.

Typical areas:

```text
EKS Cluster IAM Role
        |
        ↓
EKS Control Plane

Node IAM Role
        |
        ↓
Worker Nodes
```

Modern EKS designs may also use mechanisms such as:

```text
EKS Pod Identity
```

or:

```text
IAM Roles for Service Accounts
```

to provide AWS permissions to workloads.

Principle:

> Give workloads only the permissions they actually need.

---

# 47. EKS Add-ons

Common EKS add-ons include components for:

```text
VPC networking
DNS
kube-proxy
Storage
Observability
Load balancing
```

Examples include:

```text
CoreDNS
kube-proxy
VPC CNI
EBS CSI
```

Manage versions deliberately and test upgrades before production.

---

# 48. Terraform CI/CD with Jenkins

Terraform should ideally be integrated into CI/CD.

Basic architecture:

```text
Developer
    |
    v
GitHub
    |
    v
Jenkins
    |
    +--> terraform fmt
    |
    +--> terraform validate
    |
    +--> terraform plan
    |
    v
Approval
    |
    v
terraform apply
    |
    v
AWS
```

---

# 49. Enterprise Terraform CI/CD

Recommended flow:

```text
Developer
    |
    v
Feature Branch
    |
    v
Pull Request
    |
    v
Jenkins
    |
    +--> Checkout
    |
    +--> terraform fmt
    |
    +--> terraform validate
    |
    +--> Security Scan
    |
    +--> terraform plan
    |
    v
Pull Request Review
    |
    v
Approval
    |
    v
Production Apply
    |
    v
AWS
```

---

# 50. Terraform Security

Never store long-lived AWS credentials directly in:

```text
main.tf
variables.tf
terraform.tfvars
Git
```

Bad:

```hcl
access_key = "AKIA..."
secret_key = "..."
```

Instead use:

```text
IAM Roles
OIDC
Jenkins Credentials
AWS IAM Identity Center
Environment variables
Secret Manager
```

For CI/CD, prefer short-lived credentials through an IAM role/OIDC model when supported.

---

# 51. Enterprise Project Structure

Recommended:

```text
terraform-aws/
│
├── modules/
│   │
│   ├── vpc/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   └── README.md
│   │
│   ├── security-group/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   │
│   ├── ec2/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   │
│   ├── alb/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   │
│   └── eks/
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
│
├── environments/
│   │
│   ├── dev/
│   │   ├── backend.tf
│   │   ├── providers.tf
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── terraform.tfvars
│   │
│   ├── qa/
│   │   ├── backend.tf
│   │   ├── providers.tf
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── terraform.tfvars
│   │
│   └── prod/
│       ├── backend.tf
│       ├── providers.tf
│       ├── main.tf
│       ├── variables.tf
│       └── terraform.tfvars
│
├── scripts/
│   └── userdata/
│
├── .gitignore
├── .terraform.lock.hcl
└── README.md
```

---

# 52. Environment Separation

Enterprise environments:

```text
DEV
 |
 +-- AWS Account / Environment
 |
 +-- dev state

QA
 |
 +-- AWS Account / Environment
 |
 +-- qa state

PROD
 |
 +-- AWS Account / Environment
 |
 +-- prod state
```

For stronger isolation, separate AWS accounts are commonly preferred for production.

---

# 53. State Isolation

Do not put everything into one giant state file.

Bad:

```text
company/terraform.tfstate
```

Better:

```text
dev/network/terraform.tfstate
dev/compute/terraform.tfstate
dev/eks/terraform.tfstate

prod/network/terraform.tfstate
prod/compute/terraform.tfstate
prod/eks/terraform.tfstate
```

Benefits:

* Smaller blast radius
* Faster plans
* Easier recovery
* Better ownership
* Reduced locking contention
* Safer changes

---

# 54. Terraform Enterprise Workflow

A realistic enterprise workflow:

```text
                Developer
                    |
                    v
                Git Branch
                    |
                    v
                Pull Request
                    |
                    v
                 Jenkins
                    |
       +------------+-------------+
       |            |             |
       v            v             v
     fmt        validate       security
                                  scan
                    |
                    v
                  PLAN
                    |
                    v
              PR Review
                    |
                    v
                Approval
                    |
                    v
                  APPLY
                    |
                    v
                Terraform
                    |
          +---------+---------+
          |                   |
          v                   v
      Remote State           AWS
          |                   |
          v                   v
       S3 State       VPC / EKS / EC2
```

---

# 55. Troubleshooting

## Problem 1 — State Lock

Error:

```text
Error acquiring the state lock
```

Possible reason:

Another Terraform process is currently running.

Check:

```text
Jenkins jobs
CI/CD pipelines
Other Terraform sessions
```

If you confirm the lock is genuinely stale:

```bash
terraform force-unlock LOCK_ID
```

### ⚠️ Important

Never force-unlock just because Terraform is blocked.

First confirm that no legitimate Terraform operation is running.

---

## Problem 2 — Drift Detected

```text
Terraform plan
       ↓
Unexpected changes
```

Check:

```bash
terraform plan
```

Determine:

```text
Who changed the resource?
Why was it changed?
Should Terraform revert it?
Should the configuration be updated?
```

Never blindly add:

```hcl
ignore_changes
```

just to make the plan clean.

---

## Problem 3 — Import Plan Shows Changes

After:

```bash
terraform import ...
```

run:

```bash
terraform plan
```

Terraform may show differences.

Reason:

```text
Existing AWS configuration
        ≠
Terraform configuration
```

Update the Terraform code until the desired infrastructure is represented correctly.

---

## Problem 4 — Module Not Found

Run:

```bash
terraform init
```

Then:

```bash
terraform validate
```

Check:

```hcl
source = "./modules/ec2"
```

Verify the directory exists.

---

## Problem 5 — Provider Version Issue

Check:

```bash
terraform providers
```

Review:

```text
.terraform.lock.hcl
```

Then, when intentionally upgrading:

```bash
terraform init -upgrade
```

Review the resulting plan carefully.

---

## Problem 6 — EC2 Will Be Recreated

Run:

```bash
terraform plan
```

Look for:

```text
-/+
```

This usually means Terraform plans to destroy and recreate the resource.

Check which attribute caused replacement.

Possible causes:

```text
AMI change
Subnet change
Immutable attribute
Resource address change
Count/for_each migration
```

---

# 56. State Recovery

If you suspect state problems:

First create a backup:

```bash
terraform state pull > state-backup-$(date +%Y%m%d-%H%M%S).json
```

Then investigate.

For S3-backed state:

```text
S3 Versioning
      |
      v
Previous State Versions
      |
      v
Recovery
```

### Important

Do not manually edit:

```text
terraform.tfstate
```

unless you have a very controlled recovery procedure.

Prefer:

```text
terraform state mv
terraform state rm
terraform import
moved blocks
S3 version recovery
```

and other supported Terraform operations.

---

# 57. Production Best Practices

## 1. Use Remote State

```text
S3
```

instead of local state for team environments.

---

## 2. Enable State Protection

Use:

```text
S3 Versioning
Encryption
IAM
Locking
Audit logging
```

---

## 3. Don't Commit State

Never commit:

```text
terraform.tfstate
terraform.tfstate.*
```

---

## 4. Commit Provider Lock File

Commit:

```text
.terraform.lock.hcl
```

---

## 5. Don't Commit `.terraform`

Ignore:

```text
.terraform/
```

---

## 6. Protect Secrets

State can contain sensitive values even when an output is marked:

```hcl
sensitive = true
```

`sensitive = true` mainly controls display; it does not make the value disappear from state.

Protect the backend.

---

## 7. Use IAM Least Privilege

Terraform CI/CD should receive only the permissions it needs.

---

## 8. Use Separate State

Prefer:

```text
dev/network
dev/compute

prod/network
prod/compute
```

rather than one huge state.

---

## 9. Review Plans

Always review:

```bash
terraform plan
```

before production apply.

---

## 10. Use Pull Requests

Recommended:

```text
Code
 ↓
PR
 ↓
Plan
 ↓
Review
 ↓
Approval
 ↓
Apply
```

---

## 11. Pin Versions

Control:

```text
Terraform version
Provider version
Module version
```

and upgrade deliberately.

---

## 12. Avoid Manual AWS Changes

Preferred:

```text
Terraform
    ↓
AWS
```

Avoid:

```text
Terraform
   +
Manual Console Changes
```

because manual changes can introduce drift.

---

# 58. Terraform Interview Questions

## Q1. What is Terraform?

**Answer:**

> Terraform is an Infrastructure as Code tool used to provision and manage infrastructure declaratively using configuration files.

---

## Q2. What is Terraform state?

**Answer:**

> Terraform state stores Terraform's mapping and metadata for resources it manages, allowing Terraform to compare the desired configuration with the infrastructure it manages.

---

## Q3. Why do we use remote state?

**Answer:**

> Remote state provides centralized state storage for teams and can provide features such as locking, versioning, encryption and controlled access.

---

## Q4. Why do we use S3 for Terraform state?

**Answer:**

> S3 provides durable centralized storage, versioning, encryption and IAM-based access control, making it a common backend for Terraform on AWS.

---

## Q5. What is state locking?

**Answer:**

> State locking prevents concurrent Terraform operations from modifying the same state simultaneously.

---

## Q6. What is Terraform drift?

**Answer:**

> Drift occurs when infrastructure changes outside Terraform and the real infrastructure no longer matches the Terraform configuration or recorded state.

---

## Q7. How do you detect drift?

```bash
terraform plan
```

or:

```bash
terraform plan -refresh-only
```

---

## Q8. What is Terraform import?

**Answer:**

> Terraform import brings an existing infrastructure resource under Terraform management by associating it with a Terraform resource address in state. The Terraform configuration still needs to correctly represent the resource.

---

## Q9. What is the difference between import and drift?

```text
Import
↓
Existing resource is not managed by Terraform
↓
Bring it into Terraform state
```

Drift:

```text
Resource is already managed
↓
Someone changes it outside Terraform
↓
Terraform detects difference
```

---

## Q10. What is a Terraform module?

**Answer:**

> A Terraform module is a reusable collection of Terraform configuration that allows teams to standardize infrastructure and avoid duplicate code.

---

## Q11. What is root module?

**Answer:**

> The root module is the Terraform configuration from which Terraform commands are executed.

---

## Q12. What is child module?

**Answer:**

> A child module is a module called by the root module or another module.

---

## Q13. Count vs for_each?

**Answer:**

> `count` creates resources using numeric indexes, while `for_each` creates resources using stable keys. `for_each` is often preferable for named resources because the keys provide clearer resource identity.

---

## Q14. What happens if you change count to for_each?

Terraform sees different resource addresses.

Example:

```text
aws_instance.web[0]
```

becomes:

```text
aws_instance.web["web1"]
```

Use:

```hcl
moved {}
```

or:

```bash
terraform state mv
```

to preserve resource identity.

---

## Q15. What is lifecycle?

Answer:

> Lifecycle controls resource behavior such as create-before-destroy, prevent-destroy and ignoring selected changes.

---

## Q16. What is `depends_on`?

Answer:

> `depends_on` explicitly tells Terraform that one resource or module depends on another when Terraform cannot infer the dependency automatically.

---

## Q17. What is `.terraform.lock.hcl`?

Answer:

> It records selected provider versions and checksums so provider installation is more predictable and reproducible.

---

## Q18. Should we commit `.terraform.lock.hcl`?

**Yes**, normally.

---

## Q19. Should we commit `terraform.tfstate`?

**No.**

State should normally be stored in a protected remote backend for team environments.

---

## Q20. What is the difference between `terraform init` and `terraform plan`?

```text
terraform init
↓
Initializes providers/modules/backend

terraform plan
↓
Shows proposed infrastructure changes
```

---

## Q21. What is `terraform apply`?

> `terraform apply` executes the changes represented by the Terraform plan and updates the managed infrastructure and state.

---

## Q22. What is `terraform destroy`?

> It removes infrastructure managed by the current Terraform configuration/state, subject to lifecycle rules and dependencies.

Use extreme caution in production.

---

## Q23. What is `terraform state rm`?

> It removes a resource from Terraform state without deleting the real infrastructure.

This can be useful when intentionally handing management of a resource outside Terraform.

---

## Q24. What is `terraform state mv`?

> It changes a resource's address in Terraform state without recreating the real infrastructure.

---

## Q25. What is the difference between `-migrate-state` and `-reconfigure`?

```text
-migrate-state
↓
Move existing state to the new backend

-reconfigure
↓
Reinitialize backend configuration
without migrating the existing state
```

---

# 59. Quick Revision Cheat Sheet

## Terraform Basics

```text
Terraform
   ↓
Infrastructure as Code
```

---

## Workflow

```bash
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply
terraform destroy
```

---

## State

```text
terraform.tfstate
```

Team:

```text
S3 Remote Backend
```

---

## State Commands

```bash
terraform state list
terraform state show
terraform state mv
terraform state rm
terraform state pull
terraform state push
```

---

## Import

```bash
terraform import RESOURCE_ADDRESS RESOURCE_ID
```

Example:

```bash
terraform import aws_instance.web i-0123456789abcdef0
```

---

## Drift

```bash
terraform plan
```

Refresh-only:

```bash
terraform plan -refresh-only
```

---

## Modules

```text
modules/
└── ec2/
    ├── main.tf
    ├── variables.tf
    └── outputs.tf
```

Call:

```hcl
module "ec2" {
  source = "./modules/ec2"
}
```

---

## Count

```hcl
count = 2
```

Addresses:

```text
resource[0]
resource[1]
```

---

## For Each

```hcl
for_each = var.servers
```

Addresses:

```text
resource["web"]
resource["app"]
```

---

## Lifecycle

```hcl
lifecycle {
  create_before_destroy = true
  prevent_destroy       = true
}
```

---

## VPC

```text
VPC
 |
 +-- Public Subnet
 |      |
 |      +-- Internet Gateway
 |
 +-- Private Subnet
        |
        +-- NAT Gateway
```

---

## EKS

```text
VPC
 |
 +-- Public Subnets
 |      |
 |      +-- Load Balancer
 |
 +-- Private Subnets
        |
        +-- EKS Nodes
               |
               +-- Pods
```

---

## Enterprise CI/CD

```text
Git
 ↓
Pull Request
 ↓
Jenkins
 ↓
fmt
 ↓
validate
 ↓
security scan
 ↓
plan
 ↓
Review
 ↓
Approval
 ↓
apply
 ↓
AWS
```

---

# 🎯 Final Enterprise Terraform Architecture

```text
                         DEVELOPERS
                              |
                              v
                       GitHub / GitLab
                              |
                              v
                       Pull Request
                              |
                              v
                           Jenkins
                              |
              +---------------+---------------+
              |               |               |
              v               v               v
          terraform        validate        security
             fmt                            scan
              |               |               |
              +---------------+---------------+
                              |
                              v
                        terraform plan
                              |
                              v
                       Code Review
                              |
                              v
                          Approval
                              |
                              v
                     terraform apply
                              |
                 +------------+------------+
                 |                         |
                 v                         v
          Remote State                  AWS
                 |                         |
                 v              +----------+----------+
                S3              |          |          |
                 |              v          v          v
        +--------+--------+    VPC        EC2       EKS
        |        |        |     |                     |
       DEV      QA       PROD   |                     |
        |        |        |     ALB                Nodes
        |        |        |                           |
        +--------+--------+                          Pods
                 |
                 v
          State Versioning
          State Locking
          Encryption
          IAM
```

---

# 🏆 Real-Time Terraform Strategy

For a real enterprise DevOps environment, think like this:

```text
                 TERRAFORM
                     |
       +-------------+-------------+
       |             |             |
       v             v             v
     MODULES       STATE         CI/CD
       |             |             |
       |             v             v
       |             S3          Jenkins
       |             |             |
       |          Locking         Plan
       |          Versioning       |
       |          Encryption       v
       |                       Approval
       |                           |
       +-------------+-------------+
                     |
                     v
                    AWS
                     |
        +------------+------------+
        |            |            |
        v            v            v
       VPC          EC2          EKS
        |
        +-- Public Subnets
        |
        +-- Private Subnets
        |
        +-- NAT
        |
        +-- Route Tables
```

---

# 🔥 The Terraform Mindset

When working with Terraform, always think:

```text
1. What infrastructure do I need?
             ↓
2. Can I make it reusable?
             ↓
3. Should it be a module?
             ↓
4. Where will state be stored?
             ↓
5. How will state be locked?
             ↓
6. How will environments be separated?
             ↓
7. How will changes be reviewed?
             ↓
8. How will CI/CD execute it?
             ↓
9. How will drift be detected?
             ↓
10. How will we recover from failure?
```

---

# 🚀 Terraform Learning Roadmap

Follow this order for strong practical knowledge:

```text
                    TERRAFORM
                        |
                        v
              1. Terraform Basics
                        |
                        v
               2. Variables
                        |
                        v
                3. Resources
                        |
                        v
               4. Data Sources
                        |
                        v
                 5. Outputs
                        |
                        v
                  6. Locals
                        |
                        v
                7. Count
                        |
                        v
                8. For Each
                        |
                        v
                 9. Modules
                        |
                        v
              10. State Management
                        |
                        v
              11. Remote Backend
                        |
                        v
               12. S3 + Locking
                        |
                        v
              13. Import + Drift
                        |
                        v
             14. Lifecycle
                        |
                        v
             15. Terraform VPC
                        |
                        v
               16. Terraform EC2
                        |
                        v
                17. Terraform ALB
                        |
                        v
                 18. Terraform RDS
                        |
                        v
                 19. Terraform EKS
                        |
                        v
               20. Jenkins CI/CD
                        |
                        v
           21. Enterprise Architecture
                        |
                        v
             🚀 PRODUCTION READY
```

---

# 💡 One-Line Interview Revision

| Topic                 | Remember                                                        |
| --------------------- | --------------------------------------------------------------- |
| Terraform             | Infrastructure as Code                                          |
| Provider              | Connects Terraform to cloud/platform                            |
| Resource              | Creates/manages infrastructure                                  |
| Data Source           | Reads existing information                                      |
| Variable              | Input                                                           |
| Local                 | Reusable calculated value                                       |
| Output                | Exposes information                                             |
| Module                | Reusable infrastructure code                                    |
| State                 | Terraform's resource mapping and metadata                       |
| Backend               | Where state is stored                                           |
| Locking               | Prevents concurrent state updates                               |
| Import                | Brings existing infrastructure under Terraform state management |
| Drift                 | Real infrastructure differs from expected configuration         |
| `count`               | Index-based instances                                           |
| `for_each`            | Key-based instances                                             |
| Lifecycle             | Controls resource behavior                                      |
| `depends_on`          | Explicit dependency                                             |
| VPC                   | Network foundation                                              |
| NAT Gateway           | Private subnet outbound internet                                |
| EKS                   | Managed Kubernetes control plane                                |
| Jenkins               | CI/CD automation                                                |
| S3                    | Common AWS remote state backend                                 |
| `.terraform.lock.hcl` | Provider dependency lock file                                   |

---

# 🏁 Final Interview Statement

If an interviewer asks:

> **"Explain how you use Terraform in a real-time enterprise environment."**

A strong answer is:

> "We use Terraform as Infrastructure as Code to provision and manage AWS infrastructure. We create reusable modules for components such as VPC, security groups, EC2, ALB and EKS, while keeping environment-specific configuration under separate environment directories. Terraform state is stored remotely in S3 with appropriate locking, encryption, versioning and IAM controls. We use Git and Jenkins for CI/CD, where formatting, validation, security checks and Terraform plan are performed during the review process, followed by an approved apply. We also manage imports, detect infrastructure drift, control resource lifecycle and maintain separate state boundaries to reduce the blast radius of changes."

---

# 🔥 Golden Rules

```text
✅ Use Modules
✅ Use Remote State
✅ Protect State
✅ Enable State Versioning
✅ Use State Locking
✅ Use IAM Least Privilege
✅ Use Separate State Boundaries
✅ Review terraform plan
✅ Use Pull Requests
✅ Automate through CI/CD
✅ Pin Provider Versions
✅ Pin Module Versions
✅ Commit .terraform.lock.hcl
✅ Ignore .terraform/
✅ Never commit terraform.tfstate
✅ Never hardcode AWS credentials
✅ Avoid unnecessary manual AWS changes
✅ Treat production apply as a controlled operation
```

---

# 🎯 Final Goal

By mastering everything in this README, you should be comfortable explaining and practically working with:

```text
Terraform
   |
   +-- Basics
   +-- Variables
   +-- Resources
   +-- Data Sources
   +-- Outputs
   +-- Locals
   +-- Count
   +-- For Each
   +-- Modules
   +-- State
   +-- Remote Backend
   +-- S3
   +-- State Locking
   +-- Import
   +-- Drift
   +-- Refresh Only
   +-- Lifecycle
   +-- Dependencies
   +-- VPC
   +-- EC2
   +-- ALB
   +-- RDS
   +-- EKS
   +-- IAM
   +-- Jenkins
   +-- CI/CD
   +-- Security
   +-- Enterprise Structure
   +-- Production Best Practices
```

**This is the Terraform foundation you should be able to explain in an interview and demonstrate practically in a DevOps environment.** 🚀🔥
