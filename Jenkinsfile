pipeline {
    agent any
    stages {
    stage("clone") {
        steps {
            git branch: 'main', credentialsId: 'GIT_REPO', url: 'https://github.com/thierno953/SonarQube.git'
        }
    }
    stage("sonar analysis") {
        steps {
            nodejs(nodeJSInstallationName: "nodejs"){
                sh "npm install"
                withSonarQubeEnv('sonar') {
                    sh "npm install --save-dev mocha chai"
                    sh "npm run test"
                    sh "npm run coverage-lcov"
                    sh "npm install sonar-scanner"
                    sh "npm run sonar"
                }
            }
        }
    }
    stage("Quality Gate") {
        steps {
            timeout(time: 1, unit: 'HOURS') {
                waitForQualityGate abortPipeline: true
                }
            }
        }
   }
}