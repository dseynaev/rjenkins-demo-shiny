
write(file = "Jenkinsfile", rjenkins::pipeline(
    agent("any"),
    stages(
        stage("R Package",
            agent(
                dockerfile(
                    fileName = "Dockerfile.build",
                    reuseNode = TRUE
                )
            ),
            steps(
                R({
                      roxygen2::roxygenize('demoApp')
                      devtools::build('demoApp')
                      devtools::check('demoApp_*.tar.gz')
                })
            )
        )
    )
))
