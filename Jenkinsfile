pipeline {
    agent any

    environment {
        APP_IP = ""
    }

    stages {

        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/Harshita079/netflix-devops.git'
            }
        }

        stage('Terraform Setup') {
            steps {
                dir('terraform') {
                    sh '''
                    terraform init -input=false
                    terraform apply -auto-approve
                    '''
                }
            }
        }

        stage('Get App IP') {
            steps {
                script {
                    APP_IP = sh(
                        script: "cd terraform && terraform output -raw app_ip",
                        returnStdout: true
                    ).trim()

                    echo "App IP: ${APP_IP}"
                }
            }
        }

        stage('Deploy on EC2') {
            steps {
                sh """
                echo "Deploying to $APP_IP"

                ssh -o StrictHostKeyChecking=no ec2-user@$APP_IP << 'EOF'

                sudo yum install docker -y
                sudo systemctl start docker
                sudo systemctl enable docker

                sudo docker stop \$(sudo docker ps -aq) || true
                sudo docker rm \$(sudo docker ps -aq) || true
                sudo docker rmi \$(sudo docker images -q) || true

                rm -rf netflix-devops
                git clone https://github.com/Harshita079/netflix-devops.git

                cd netflix-devops
                sudo docker build -t netflix-app .

                sudo docker run -d -p 80:80 --name netflix-container netflix-app

                EOF
                """
            }
        }
    }

    post {
        success {
            echo "✅ Deployment Successful!"
        }
        failure {
            echo "❌ Deployment Failed!"
        }
    }
}