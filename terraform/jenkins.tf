user_data = <<-EOF
#!/bin/bash

yum update -y
yum install docker git -y
systemctl start docker
systemctl enable docker

cd /home/ec2-user

# Clone repo
git clone https://github.com/Harshita079/netflix-devops.git

# Create config directory
mkdir -p /var/jenkins_home/casc_configs

# Copy Jenkins config
cp netflix-devops/jenkins/jenkins.yaml /var/jenkins_home/casc_configs/

# Run Jenkins with config
docker run -d \
  -p 8080:8080 \
  -p 50000:50000 \
  -v /var/jenkins_home:/var/jenkins_home \
  -e CASC_JENKINS_CONFIG=/var/jenkins_home/casc_configs \
  --name jenkins \
  jenkins/jenkins:lts

EOF