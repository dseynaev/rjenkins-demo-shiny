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
                sh script: '''
                R  -e "{
                    roxygen2::roxygenize(\"demoApp\")
                    devtools::build(\"demoApp\")
                    devtools::check(\"demoApp_*.tar.gz\")
                }"
                '''
            }
        }
    }
}

