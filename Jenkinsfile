pipeline {
    agent {
	docker { image 'adoptopenjdk:11-jdk-hotspot' }
    }
    stages {
        stage('Build') { 
            steps {
                sh './gradlew -PbuildNumber=${BUILD_NUMBER} test assemble'
            }
        }
    }
}