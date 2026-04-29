pipeline {
    agent any

    stages {

        stage('Checkout') {
            steps {
                git 'https://github.com/Harshita079/netflix-devops.git'
            }
        }

        stage('Terraform') {
            steps {
                dir('terraform') {
                    sh '''
                    terraform init
                    terraform apply -auto-approve
                    '''
                }
            }
        }

        stage('Get IP') {
            steps {
                script {
                    env.APP_IP = sh(
                        script: "cd terraform && terraform output -raw app_ip",
                        returnStdout: true
                    ).trim()
                }
            }
        }

        stage('Deploy') {
            steps {
                sh '''
                chmod +x scripts/deploy.sh
                ./scripts/deploy.sh $APP_IP
                '''
            }
        }
    }
}