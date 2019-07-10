pipeline {
    agent any
    stages {
        stage('R Package') {
            steps {
                sh '''
                R  -e \'{
                    roxygen2::roxygenize("myPackage")
                    devtools::build("myPackage")
                    devtools::check("myPackage_*.tar.gz")
                }\'
                '''
            }
        }
    }
}

