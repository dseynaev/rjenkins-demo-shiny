
# http://ec2-52-212-76-72.eu-west-1.compute.amazonaws.com/

# rjenkins

# http://ec2-18-202-162-216.eu-west-1.compute.amazonaws.com/jenkins
# 114fba0a5883d90875f45d46e9440c784b
jc <- rjenkins::jenkins("http://ec2-18-202-162-216.eu-west-1.compute.amazonaws.com/jenkins", user = "dseynaeve", token = "114fba0a5883d90875f45d46e9440c784b", contextPath = "jenkins")

write(file = "Jenkinsfile", rjenkins::pipeline(
    agent("any"),
    stages(
        stage("R Package",
            agent(
                dockerfile("Dockerfile.build", reuseNode = TRUE)
            ),
            steps(
                R(roxygen2::roxygenize('demoApp')),
                sh("R CMD build demoApp"),
                sh("R CMD check demoApp_*.tar.gz")
            )
        ),
        stage("Docker Image",
            steps(
                sh("docker build -t openanalytics/rjenkins-demo-app .")
            )
        )
    ),
    post(
        success(
            step("archiveArtifacts", artifacts = "*.tar.gz, *.pdf"),
            withDockerRegistry(credentialsId = "hub-openanalytics", url = "",
                sh("docker push openanalytics/rjenkins-demo-app")
            )
        )
    )
))

# git commit & push

mbp <- jc %>% rjenkins::createJob("demoApp",
    rjenkins::multibranchPipelineConfig(
        rjenkins::gitHubBranchSource(
            owner = "dseynaev",
            repository = "rjenkins-demo-shiny",
            credentialsId = "github-dseynaev")))

mbp %>% rjenkins::scheduleBuild()

job <- mbp %>% rjenkins::getJob("master")

summary(job)

job %>% rjenkins::getBuildLog() %>% cat

job %>% rjenkins::browse()

## rrundeck

# http://ec2-18-202-162-216.eu-west-1.compute.amazonaws.com/rundeck
# ZQipYMaO6YpH2GkLoE6Q3ezDTd74a8rQ
rc <- rrundeck::rundeck("http://ec2-18-202-162-216.eu-west-1.compute.amazonaws.com/rundeck", user = "dseynaeve", token = "ZQipYMaO6YpH2GkLoE6Q3ezDTd74a8rQ", contextPath = "rundeck")

rc %>% rrundeck::listProjects()

rc %>% rrundeck::getProject("UseR2019") %>% rrundeck::listJobs()

rc %>% rrundeck::getProject("UseR2019") %>%
    rrundeck::getJob(name = "docker-pull") %>% 
    rrundeck::run(list(image = "openanalytics/rjenkins-demo-app"), follow = TRUE)

# http://ec2-52-212-76-72.eu-west-1.compute.amazonaws.com/
