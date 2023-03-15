data "aws_ami" "amazon-linux-2" {
  most_recent      = true
  owners           = ["amazon"]

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

resource "aws_instance" "bastion" {
  ami           = data.aws_ami.amazon-linux.id
  instance_type = var.bastion_instance_type
  key_name      = var.ssh_key_name
  subnet_id     = var.subnet_id

  tags = {
    Name = var.bastion_name
  }

  security_groups = ["${aws_security_group.allow_ssh_icmp.id}"]

provisioner "file" {
  source      = "~/.ssh/first-key"
  destination = "/ec2-user/home/first-key"

}
}

resource "aws_security_group" "allow_ssh_icmp" {
  name        = "allow_ssh_icmp"
  description = "Allow SSH and ALL ICMP IPV4 inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    description      = "SSH from VPC"
    from_port        = 22       
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = [var.cidr_block]
  }
  
 ingress {
    description      = "ALL ICMP IPV4 from VPC"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = [var.cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_ssh"
  }
}