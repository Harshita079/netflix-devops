#!/bin/bash

APP_IP=$1

echo "Connecting to $APP_IP..."

ssh -o StrictHostKeyChecking=no ec2-user@$APP_IP << EOF

echo "Pulling latest code..."
cd /home/ec2-user || exit
rm -rf netflix-devops
git clone https://github.com/Harshita079/netflix-devops.git
cd netflix-devops

echo "Stopping old container..."
docker stop netflix-container || true
docker rm netflix-container || true
docker rmi netflix-app || true

echo "Building new image..."
docker build -t netflix-app .

echo "Running new container..."
docker run -d -p 80:80 --name netflix-container netflix-app

echo "Deployment done!"

EOF