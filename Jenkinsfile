pipeline {
    agent any
    stages {
        stage('R Package') {
            agent {
                dockerfile {
                    filename 'Dockerfile.build'
                    reuseNode true
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
                withDockerRegistry([credentialsId: "hub-openanalytics"]) {
                    sh 'docker push openanalytics/rjenkins-demo-app'
                }
            }
        }
    }
    post {
        success {
            archiveArtifacts artifacts: '*.tar.gz, *.pdf'
        }
    }
}

