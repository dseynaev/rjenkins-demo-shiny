
#' Run the demo application
#' @param port port to use for webserver
#' @param ... additional arguments to \code{\link[shiny]{runApp}}
#' @return nothing
#' @importFrom shiny runApp
#' @importFrom methods getPackageName
#' @export
runDemoApp <- function(port = 3838, ...) {
  
  tmpDir <- tempdir()
  setwd(tmpDir)
  
  thisPackage <- getPackageName()
  
  dir.create(tmpDir, showWarnings = FALSE)
  
  file.copy(system.file("app", package = thisPackage),
      tmpDir, recursive = TRUE)
  
  runApp(appDir = file.path(tmpDir, "app"), port = port, ...)
  
}
