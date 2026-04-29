resource "aws_instance" "app" {
  ami           = "ami-0c02fb55956c7d316"
  instance_type = "t2.micro"
  key_name      = "netflix-key"

  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.netflix_sg.id]

  user_data = <<-EOF
#!/bin/bash

yum update -y

# Install Docker + Git
yum install docker git -y

# Start Docker
systemctl start docker
systemctl enable docker

cd /home/ec2-user

# Clone repo
git clone https://github.com/Harshita079/netflix-devops.git

cd netflix-devops

# Build image
docker build -t netflix-app .

# Run container (force clean run)
docker rm -f netflix-container || true
docker run -d -p 80:80 --name netflix-container netflix-app

EOF

  tags = {
    Name = "Netflix-App"
  }
}