#!/bin/bash

IP=$1

scp -o StrictHostKeyChecking=no -r app ec2-user@$IP:/home/ec2-user/

ssh -o StrictHostKeyChecking=no ec2-user@$IP << EOF
cd /home/ec2-user/app
docker stop netflix || true
docker rm netflix || true
docker build -t netflix .
docker run -d -p 80:80 --name netflix netflix
EOF