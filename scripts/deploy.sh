stage('Deploy') {
    steps {
        sh '''
        ssh -o StrictHostKeyChecking=no ec2-user@$APP_IP << EOF

        docker stop $(docker ps -aq) || true
        docker rm $(docker ps -aq) || true
        docker rmi $(docker images -q) || true

        rm -rf netflix-devops
        git clone https://github.com/Harshita079/netflix-devops.git

        cd netflix-devops
        docker build -t netflix-app .
        docker run -d -p 80:80 netflix-app

        EOF
        '''
    }
}