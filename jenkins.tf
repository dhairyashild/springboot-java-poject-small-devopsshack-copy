resource "aws_instance" "jenkin-ec2" {
  ami               = data.aws_ami.example.id
  instance_type     = var.instance_type-jenkins
  key_name      = "killi"

  vpc_security_group_ids = [aws_security_group.jenkins-ec2.id]
  subnet_id = module.vpc.public_subnets[0]
  tags = {
    Name= "jenkins"
  }
  lifecycle {
    ignore_changes= [tags]
  }
  user_data = <<-EOF
 
#!/bin/bash


# Update package lists
sudo apt update -y

# Install Java (required for Jenkins)
sudo apt install -y default-jre

# Install Jenkins
wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt update -y
sudo apt install -y jenkins



# Verify installations
java -version
jenkins --version
terraform version

EOF


}


data "aws_ami" "example" {
  most_recent = true

  owners = ["aws-marketplace"]

   filter {
    name   = "description"
    values = ["Canonical, Ubuntu, 20.04 LTS, amd64 focal image build on 2024-02-28"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

#jenkins ec2 sg
resource "aws_security_group" "jenkins-ec2" {
  #name   = var.sgname # define this variable
  vpc_id = module.vpc.vpc_id # define this variable

  # Ingress rules
  dynamic "ingress" {
    for_each = var.port # define this variable
    content {
      description = "TLS from VPC"
      from_port   = ingress.value #ingress.value-gave value from (ingress) meaning dynamic block name and (value) taken from for_each = var.port   
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  # Egress rule
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.sg-tag # define this variable
  }
}



#######################################variables
variable "sg-tag" {
    default = "Name=jenkins-sg"
}

variable "port" {
  type    = list(number)
  default = [8080,22] # Example values, adjust as needed.
}
 
 variable "instance_type-jenkins" {
    default = "t2.medium"
   
 }