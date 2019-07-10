pipeline {
    agent any
    stages {
        stage('R Package') {
            agent {
                docker {
                    image 'rocker/r-ver:3.5.3'
                }
            }
            steps {
                sh 'R  -e \'roxygen2::roxygenize("demoApp")\''
                sh 'R CMD build demoApp'
                sh 'R CMD check demoApp_*.tar.gz'
            }
        }
        stage('Docker Image') {
            steps {
                sh 'docker build -t openanalytics/rjenkins-demo-app .'
                sh 'docker push openanalytics/rjenkins-demo-app'
            }
        }
    }
    post {
        success {
            archiveArtifacts artifacts: '*.tar.gz, *.pdf'
        }
    }
}

