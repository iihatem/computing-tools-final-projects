pipeline {
    agent any

    environment {
        IMAGE_NAME       = 'cicd-demo-app'
        TF_IN_AUTOMATION = 'true'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
                sh 'ls -la'
            }
        }

        stage('Build Image') {
            steps {
                sh '''
                    docker build \
                        -t ${IMAGE_NAME}:${BUILD_NUMBER} \
                        -t ${IMAGE_NAME}:latest \
                        .
                    docker images | grep ${IMAGE_NAME}
                '''
            }
        }

        stage('Terraform Init') {
            steps {
                dir('terraform') {
                    sh 'terraform init -input=false'
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                dir('terraform') {
                    sh 'terraform apply -auto-approve -input=false -var="image_tag=${BUILD_NUMBER}"'
                }
            }
        }

        stage('Verify Deployment') {
            steps {
                sh 'docker ps --filter "name=${IMAGE_NAME}"'
            }
        }
    }

    post {
        success {
            echo "Build ${BUILD_NUMBER} deployed. App available at http://localhost:8081"
        }
        failure {
            echo "Build ${BUILD_NUMBER} failed."
        }
    }
}
