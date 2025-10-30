pipeline {
    agent any

    environment {
        IMAGE_TAG = "v${env.BUILD_NUMBER}"
        IMAGE_NAME = "dummy-app:${IMAGE_TAG}"
    }

    stages {
        stage('Build Docker Image') {
            steps {
                script {
                    docker.build(IMAGE_NAME, "--build-arg BUILD_NUMBER=${IMAGE_TAG} .")
                }
            }
        }

        stage('Push to Minikube') {
            steps {
                // This will now work because Jenkins and Minikube are "neighbors"
                sh "minikube image load ${IMAGE_NAME}"
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                // This 'kubectl' will also work because it's on the same network

                // First, update the deployment.yaml with the new image tag
                sh "sed -i 's|image: .*|image: ${IMAGE_NAME}|g' deployment.yaml"

                // Now, kubectl apply will work
                sh "kubectl apply -f deployment.yaml"
                sh "kubectl apply -f service.yaml"
                sh "kubectl apply -f hpa.yaml"
            }
        }
    }

    post {
        success {
            echo "Pipeline successful! App ${IMAGE_NAME} is deployed."
        }
        failure {
            echo "Pipeline failed."
        }
    }
}
