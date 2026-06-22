pipeline {
    agent any

    environment {
        AWS_REGION = 'ap-south-1'
        ECR_REPO   = 'tulasi-devops-app'
    }

    stages {

        stage('Clone Code') {
            steps {
                echo 'Cloning code from GitHub...'
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                echo 'Building Docker image...'
                sh 'docker build -t tulasi-devops-app .'
            }
        }

        stage('Test Container') {
            steps {
                echo 'Testing container runs correctly...'
                sh 'docker run -d -p 8081:80 --name test-app tulasi-devops-app'
                sh 'sleep 3'
                sh 'curl -f http://localhost:8081 || exit 1'
                sh 'docker stop test-app'
                sh 'docker rm test-app'
            }
        }

        stage('Push to ECR') {
            steps {
                echo 'Pushing Docker image to AWS ECR...'
                sh '''
                    aws ecr get-login-password --region $AWS_REGION | \
                    docker login --username AWS \
                    --password-stdin \
                    $(aws sts get-caller-identity --query Account \
                    --output text).dkr.ecr.$AWS_REGION.amazonaws.com
                '''
                sh '''
                    docker tag tulasi-devops-app \
                    $(aws sts get-caller-identity --query Account \
                    --output text).dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPO:latest
                '''
                sh '''
                    docker push \
                    $(aws sts get-caller-identity --query Account \
                    --output text).dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPO:latest
                '''
            }
        }

        stage('Deploy') {
            steps {
                echo 'Deploying container...'
                sh 'docker stop devops-app || true'
                sh 'docker rm devops-app || true'
                sh 'docker run -d -p 80:80 --name devops-app tulasi-devops-app'
                echo 'App deployed! Visit http://localhost'
            }
        }
    }

    post {
        success {
            echo '✅ Pipeline completed successfully!'
        }
        failure {
            echo '❌ Pipeline failed — check logs above!'
        }
    }
}
