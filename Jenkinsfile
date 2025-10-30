pipeline {
    agent any

    environment {
        // We use the Jenkins build number as our image tag
        IMAGE_TAG = "v${env.BUILD_NUMBER}"
        IMAGE_NAME = "dummy-app:${IMAGE_TAG}"
        // This tells kubectl inside Jenkins where to find the "password" file
        KUBECONFIG = "/var/jenkins_home/.kube/config"
    }

    stages {
        stage('Build Docker Image') {
            steps {
                script {
                    // This uses the Docker commands inside Jenkins
                    docker.build(IMAGE_NAME, "--build-arg BUILD_NUMBER=${IMAGE_TAG} .")
                }
            }
        }

        stage('Push to Minikube') {
            steps {
                // This pushes the new image from Jenkins's Docker into Minikube's Docker
                // This works because 'minikube' is now a command inside the container
                sh "minikube image load ${IMAGE_NAME}"
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                // First, update the deployment.yaml with the new image tag
                sh "sed -i 's|image: .*|image: ${IMAGE_NAME}|g' deployment.yaml"

                // Now, use kubectl to apply all our files
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
