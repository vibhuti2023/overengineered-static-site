pipeline {
    agent any

    environment {
        IMAGE_NAME = "overengineered-static-site"
        REGISTRY = "692859949881.dkr.ecr.us-east-1.amazonaws.com"
    }

    stages {
        stage('Build') {
            steps {
                script {
                    sh 'docker build -t $IMAGE_NAME:latest .'
                }
            }
        }

        stage('Push Image') {
            steps {
                script {
                    sh 'aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin $REGISTRY'
                    sh 'docker tag $IMAGE_NAME:latest $REGISTRY/$IMAGE_NAME:latest'
                    sh 'docker push $REGISTRY/$IMAGE_NAME:latest'
                }
            }
        }

        stage('Deploy') {
            steps {
                script {
                    sh 'docker pull $REGISTRY/$IMAGE_NAME:latest'
                    sh 'docker stop static-site || true'
                    sh 'docker rm static-site || true'
                    sh 'docker run -d -p 80:80 --name static-site $REGISTRY/$IMAGE_NAME:latest'
                }
            }
        }
    }
}

