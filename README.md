This Terraform module creates a Bastion host in an existing VPC to allow secure remote access to instances in private subnets.


Usage

To use this module in your Terraform code, you can include the following block:


```hcl

provider "aws" {
  region = "us-east-1"
}
module "bastion_host" {
  source      = "git::https://github.com/theaksel/terraform-aws-bastion-host.git"
  vpc_id      = "vpc-12345678"
  subnet_id   = ["subnet-01", "subnet-02"]
  ssh_key_name    = "my-ssh-key"
  bastion_instance_type = "t2.micro"
  cidr_block = ["0.0.0.0/0"]
  bastion_name = "bastion-host"
}
```

Inputs

This module accepts the following input variables:

| Name                  | Desciption                                                   | Type   | Default      | Required |
| --------------------- |:------------------------------------------------------------:|------: |--------------|----------|
| vpc_id                | ID of the VPC where the Bastion host will be created         | string | n/a          | yes      |
| subnet_id             | List of subnet IDs where the Bastion host will be deployed   | string | n/a          | yes      |
| ssh_key_name          | Name of the SSH key pair to use for the Bastion host         | string | n/a          | yes      |
| bastion_instance_type | Instance type for the Bastion host                           | string | t2.micro     | no       |
| cidr_block            | List of CIDR blocks allowed to connect to the Bastion host   | string | 0.0.0.0/0    | no       |
| bastion_name          | The name of the Bastion Host                                 | string | bastion-host | no       |


How It Works

This module creates an EC2 instance in the specified subnets using the specified instance type. When EC2 launching, the provisioner takes your key.pem from your local and copy it to the Bastion Host EC2 Instance.

The security group for the instance allows inbound SSH and All ICMP IPV4 traffic from the specified CIDR blocks. Outbound traffic is allowed to all destinations.

Requirements

This module requires an existing VPC with at least one public subnet and at least one private subnet. The private subnets must have a route to a NAT gateway or other egress solution to allow outbound traffic from the Bastion host to the internet. You must also have an SSH key pair to use for connecting to the Bastion host. You have to add your key.pem path in the provisioner source.
