pipeline {
    agent any

    environment {
        BUCKET_NAME = "overengineered-static-site-assets"
        AWS_REGION = "us-east-1"
        DISTRIBUTION_ID = "EXBWVR3BQ6UCD"  // Replace with your actual CloudFront Distribution ID
    }

    stages {
        stage('Build') {
            steps {
                script {
                    sh 'npm run build'
                }
            }
        }

        stage('Deploy to S3') {
            steps {
                script {
                    sh 'aws s3 sync public s3://$BUCKET_NAME --acl public-read'
                }
            }
        }

        stage('Invalidate CloudFront Cache') {
            steps {
                script {
                    sh 'aws cloudfront create-invalidation --distribution-id $DISTRIBUTION_ID --paths "/*"'
                }
            }
        }
    }
}
