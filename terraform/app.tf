resource "aws_instance" "app" {
  ami           = "ami-0c02fb55956c7d316"
  instance_type = "t2.micro"
  key_name      = "netflix-key"

  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.netflix_sg.id]

  user_data = <<-EOF
#!/bin/bash
yum update -y
yum install docker -y
systemctl start docker
systemctl enable docker
EOF

  tags = {
    Name = "Netflix-App"
  }
}