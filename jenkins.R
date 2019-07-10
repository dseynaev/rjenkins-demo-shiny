
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

library(rjenkins)

mjob <- jc %>% createJob("demoApp",
    multibranchPipelineConfig(
        gitHubBranchSource(owner = "dseynaev", repository = "rjenkins-demo-shiny",
            credentialsId = "github-dseynaev")))

mjob %>% scheduleBuild()

job <- mjob %>% getJob("master")

summary(job)
