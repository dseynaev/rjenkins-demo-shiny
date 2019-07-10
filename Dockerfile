FROM openanalytics/shiny

COPY demoApp_*.tar.gz /tmp/
RUN R CMD INSTALL /tmp/demoApp_*.tar.gz && rm /tmp/demoApp_*.tar.gz

CMD ["R", "-e", "demoApp::runDemoApp()"]
