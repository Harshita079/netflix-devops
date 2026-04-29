provider "aws" {
  region = "us-east-1"
}

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

resource "aws_instance" "jenkins" {
  ami           = "ami-0c02fb55956c7d316"
  instance_type = "t2.micro"
  key_name      = "netflix-key"

  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.netflix_sg.id]

  user_data = <<EOF
#!/bin/bash

yum update -y
yum install docker git -y

systemctl start docker
systemctl enable docker

cd /home/ec2-user

# Clone your repo
git clone https://github.com/Harshita079/netflix-devops.git

# Setup Jenkins config directory
mkdir -p /var/jenkins_home/casc_configs

# Copy JCasC config
cp netflix-devops/jenkins/jenkins.yaml /var/jenkins_home/casc_configs/

# Run Jenkins container
docker run -d \
  -p 8080:8080 \
  -p 50000:50000 \
  -v /var/jenkins_home:/var/jenkins_home \
  -e CASC_JENKINS_CONFIG=/var/jenkins_home/casc_configs \
  --name jenkins \
  jenkins/jenkins:lts

EOF

  tags = {
    Name = "Jenkins-Server"
  }
}