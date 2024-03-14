pipeline {
    agent any
    environment {
        registry = "074465317714.dkr.ecr.us-east-1.amazonaws.com/test1"
    }
   
    stages {
        stage('Building image') {
            steps {
                script {
                    dockerImage = docker.build registry 
                }
            }
        }
   
        // Uploading Docker images into AWS ECR
        stage('Pushing to ECR') {
            steps {  
                script {
                    sh 'aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 074465317714.dkr.ecr.us-east-1.amazonaws.com'
                    sh 'docker push 074465317714.dkr.ecr.us-east-1.amazonaws.com/test1:latest'
                }
            }
        }

        stage('K8S Deploy') {
            steps {   
                script {
                    withKubeConfig([credentialsId: 'K8S', serverUrl: '']) {
                        sh ('kubectl apply -f  deployment.yaml')
                    }
                }
            }
        }

        stage('Ask for deployment removal') {
            steps {
                script {
                    // Prompt the user
                    def userInput = input(
                        id: 'userInput',
                        message: 'Do you want to remove the deployment?',
                        parameters: [boolean(defaultValue: false, description: 'Proceed with deployment removal?')]
                    )
                    if (userInput) {
                        // Remove deployment
                        withKubeConfig([credentialsId: 'K8S', serverUrl: '']) {
                            sh('kubectl delete -f deployment.yaml')
                        }
                    } else {
                        echo 'Deployment removal cancelled.'
                    }
                }
            }
        }
    }
}
