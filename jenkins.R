
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
                R(roxygen2::roxygenize('demoApp')),
                sh("R CMD build demoApp"),
                sh("R CMD check demoApp_*.tar.gz")
            )
        )
    ),
    post(
        step("archiveArtifacts", artifacts = "*.tar.gz, *.pdf")
    )
))

library(rjenkins)

mjob <- jc %>% createJob("demoApp",
    multibranchPipelineConfig(
        gitHubBranchSource(owner = "dseynaev", repository = "rjenkins-demo-shiny",
            credentialsId = "github-dseynaev")))

mjob %>% scheduleBuild()

job <- mjob %>% getJob("master")

job %>% scheduleBuild()

summary(job)
