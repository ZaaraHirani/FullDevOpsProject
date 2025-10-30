pipeline {
    agent any

    environment {
        IMAGE_TAG = "v${env.BUILD_NUMBER}"
        IMAGE_NAME = "dummy-app:${IMAGE_TAG}"
        // This is the path to the config file *inside* the container
        KUBECONFIG_PATH = "/var/jenkins_home/.kube/config"
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
                // This command uses the .minikube map we gave it
                sh "minikube image load ${IMAGE_NAME}"
            }
        }

        // --- THIS IS THE NEW, CRITICAL FIX ---
        stage('Fix KubeConfig Paths') {
            steps {
                sh "echo 'Fixing KubeConfig paths...'"
                // This command replaces all instances of your *host* path
                // with the *container's* path.
                sh "sed -i 's|/home/zaara_hirani|/var/jenkins_home|g' ${KUBECONFIG_PATH}"
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                // Set the KUBECONFIG env var *for this stage*
                withEnv(["KUBECONFIG=${KUBECONFIG_PATH}"]) {
                    // First, update the deployment.yaml with the new image tag
                    sh "sed -i 's|image: .*|image: ${IMAGE_NAME}|g' deployment.yaml"

                    // Now, kubectl apply will work because the paths are fixed
                    sh "kubectl apply -f deployment.yaml"
                    sh "kubectl apply -f service.yaml"
                    sh "kubectl apply -f hpa.yaml"
                }
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
