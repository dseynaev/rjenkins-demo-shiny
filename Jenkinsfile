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
                sh 'R  -e \'devtools::build("demoApp")\''
                sh 'R  -e \'devtools::check("demoApp_*.tar.gz")\''
            }
        }
    }
}

