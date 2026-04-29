provider "aws" {
  region = "us-east-1"
}

# Security Group
resource "aws_security_group" "netflix_sg" {
  name = "netflix-sg"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
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

# Jenkins EC2
resource "aws_instance" "jenkins" {
  ami           = "ami-0c02fb55956c7d316"
  instance_type = "t2.micro"
  key_name      = "netflix-key"

  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.netflix_sg.id]

  user_data = <<-EOF
#!/bin/bash

# Update system
yum update -y

# Install Docker
yum install docker -y

# Start Docker
systemctl start docker
systemctl enable docker

# Pull Jenkins image
docker pull jenkins/jenkins:lts

# Run Jenkins container (FULLY AUTOMATED)
docker run -d \
  -p 8080:8080 \
  -p 50000:50000 \
  --restart always \
  --name jenkins \
  jenkins/jenkins:lts

EOF

  tags = {
    Name = "Jenkins-Server"
  }
}