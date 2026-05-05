#!/bin/bash

APP_IP=$1

echo "Connecting to $APP_IP..."

ssh -o StrictHostKeyChecking=no ec2-user@$APP_IP << 'EOF'

echo "Cleaning old setup..."
docker stop netflix-container || true
docker rm netflix-container || true
docker rmi netflix-app || true

echo "Removing old code..."
rm -rf netflix-devops

echo "Cloning fresh code..."
git clone https://github.com/Harshita079/netflix-devops.git

cd netflix-devops || exit

echo "Building new Docker image..."
docker build -t netflix-app .

echo "Running new container..."
docker run -d -p 80:80 --name netflix-container netflix-app

echo "Deployment completed!"

EOF