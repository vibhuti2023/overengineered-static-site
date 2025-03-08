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

        stage('Deploy') {
    steps {
        script {
            try {
                sh 'aws s3 sync . s3://overengineered-static-site-assets --delete'
            } catch (Exception e) {
                echo "Deployment failed! Rolling back..."
                build job: 'Rollback'
            }
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
stage('Rollback') {
    steps {
        script {
            sh '''
            # Find the previous version of the site
            LATEST=$(aws s3api list-object-versions --bucket overengineered-static-site-assets --query "Versions[?IsLatest==\`true\`].VersionId" --output text)
            PREV=$(aws s3api list-object-versions --bucket overengineered-static-site-assets --query "Versions[?IsLatest==\`false\`].VersionId" --output text | head -n1)

            # If a previous version exists, restore it
            if [[ ! -z "$PREV" ]]; then
                aws s3api copy-object --bucket overengineered-static-site-assets --copy-source overengineered-static-site-assets/index.html?versionId=$PREV --key index.html
                echo "Rollback successful!"
            else
                echo "No previous version found!"
            fi
            '''
        }
    }
}
