pipeline {
    agent any
    triggers {
        pollSCM 'H/10 * * * *'
    }
    stages {
        stage('Init') {
            steps {
                sh 'java -version'
                sh 'mvn -version'
                sh 'git --version'
            }
        }
        stage('SCM') {
            steps {
                git 'https://github.com/dav1dli/springboot-example.git'
            }
        }
        stage ('Test') {
            steps {
                sh 'mvn install'
                junit '**/target/surefire-reports/TEST-*.xml'
            }
        }
        stage ('Image') {
            steps {
                sh 'docker build -t springboot-test .'
                sh 'docker tag springboot-test davidlitest/springboot:1.0.${BUILD_NUMBER}'
                withCredentials([usernamePassword(credentialsId: 'docker.com', passwordVariable: 'PASSWORD', usernameVariable: 'USERNAME')]) {
                    sh 'docker login docker.io -u ${USERNAME} -p ${PASSWORD} && docker push davidlitest/springboot:1.0.${BUILD_NUMBER}'
                }
            }
        }
		stage ('Deploy') {
			steps {
				withKubeConfig([credentialsId: 'jenkins-bot', serverUrl: 'https://192.168.39.58:8443']) {
                    sh '''
						sed -i "s/latest/1.0.${BUILD_NUMBER}/"  k8s/deployment.yaml
						/usr/local/bin/kubectl apply -f k8s/deployment.yaml
						/usr/local/bin/kubectl apply -f k8s/service.yaml
					'''
                }
			}
		}
    }
}
