pipeline {
    agent any
    tools {
        jdk 'jdk17'           // Define the JDK to use
        maven 'maven3'         // Define the Maven version to use
    }
    environment {
        SCANNER_HOME = tool 'sonar-scanner' // SonarQube scanner tool
    }
    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'demodeploy', url: 'https://github.com/sureshmaran123/demodeploy.git'
            }
        }
        stage('Compile') {
            steps {
                sh 'mvn clean compile'
            }
        }
        stage('Package') {
            steps {
                sh 'mvn package'
            }
        }
        stage('SonarQube Analysis') {
            steps {
                script {
                    def sonarStatus = sh(script: '''$SCANNER_HOME/bin/sonar-scanner -X \
                        -Dsonar.host.url=http://13.201.95.2:9000 \
                        -Dsonar.login=sqa_47f24534c9c8b4700d1840701a9b638bea7a9972 \
                        -Dsonar.projectKey=demo \
                        -Dsonar.projectName=demo \
                        -Dsonar.java.binaries=target''', returnStatus: true)
                    if (sonarStatus != 0) {
                        error "SonarQube analysis failed"
                    }
                }
            }
        }
        stage('Build Application') {
            steps {
                sh "mvn clean install -DskipTests=true"
            }
        }
        stage('Build & Push Docker Image') {
            steps {
                script {
                    withDockerRegistry(credentialsId: '5ad12753-c51c-4f44-9c2f-09ea2eeb17cc', toolName: 'docker') {
                        sh "docker build -t demo:latest -f ./Dockerfile ."
                        sh "docker tag demo:latest sureshmaran/demo:latest"
                        sh "docker push sureshmaran/demo:latest"
                    }
                }
            }
        }
        stage('Deploy to Container') {
            steps {
                script {
                    // Remove the old container if it exists
                    sh '''
                    if [ "$(docker ps -aq -f name=demo)" ]; then
                        docker stop demo || true
                        docker rm demo || true
                    fi
                    '''
                    // Run the new container
                    sh 'docker run -d --name demo -p 8070:8070 sureshmaran/demo:latest'
                }
            }
        }
    }
}
