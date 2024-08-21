pipeline {
    agent any

    environment {
        AWS_CREDENTIALS = credentials('aws-credentials-id') // Jenkins credential ID for AWS
        DOCKER_REPO = '<your-ecr-repo-url>'
        EKS_CLUSTER_NAME = 'my-eks-cluster'
        KUBECONFIG = 'kubeconfig'
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/ChineduOkeke/DevOps.git'
            }
        }

        stage('Terraform Init') {
            steps {
                script {
                    dir('terraform') {
                        withAWS(credentials: AWS_CREDENTIALS, region: 'us-west-2') {
                            sh 'terraform init'
                        }
                    }
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                script {
                    dir('terraform') {
                        withAWS(credentials: AWS_CREDENTIALS, region: 'us-west-2') {
                            sh 'terraform plan -out=tfplan'
                        }
                    }
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                script {
                    dir('terraform') {
                        withAWS(credentials: AWS_CREDENTIALS, region: 'us-west-2') {
                            sh 'terraform apply tfplan'
                        }
                    }
                }
            }
        }

        stage('Build Docker Image with Docker Compose') {
            steps {
                script {
                    sh 'docker-compose -f docker-compose.yml build'
                }
            }
        }

        stage('Push Docker Image to ECR') {
            steps {
                script {
                    withAWS(credentials: AWS_CREDENTIALS, region: 'us-west-2') {
                        sh '$(aws ecr get-login --no-include-email)'
                        sh 'docker-compose -f docker-compose.yml push'
                    }
                }
            }
        }

        stage('Deploy to EKS') {
            steps {
                script {
                    withAWS(credentials: AWS_CREDENTIALS, region: 'us-west-2') {
                        sh "aws eks update-kubeconfig --name ${EKS_CLUSTER_NAME} --kubeconfig ${KUBECONFIG}"
                        sh "kubectl apply -f k8s/deployment.yaml --kubeconfig ${KUBECONFIG}"
                        sh "kubectl apply -f k8s/service.yaml --kubeconfig ${KUBECONFIG}"
                    }
                }
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}

