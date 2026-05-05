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

        stage('Get Application IP') {
            steps {
                script {
                    APP_IP = sh(
                        script: "cd terraform && terraform output -raw app_ip",
                        returnStdout: true
                    ).trim()

                    echo "App IP is: ${APP_IP}"
                }
            }
        }

        stage('Deploy Application') {
            steps {
                sh '''
                chmod +x scripts/deploy.sh

                echo "Deploying to $APP_IP..."

                ./scripts/deploy.sh $APP_IP
                '''
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