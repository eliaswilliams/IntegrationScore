#' Launch Shiny App for IntegrationScore
#'
#' A function that launches the Shiny app for IntegrationScore
#' The purpose of this app is
#'
#' @return No return value but open up a Shiny page.
#'
#' @examples
#' \dontrun{
#'
#' IntegrationScore::runIntegrationScore()
#' }
#'
#' @references
#' Grolemund, G. (2015). Learn Shiny - Video Tutorials. \href{https://shiny.rstudio.com/tutorial/}{Link}
#'
#' @export
#' @importFrom shiny runApp

runIntegrationScore <- function() {
        appDir <- system.file("shiny-scripts",
                              package = "IntegrationScore")
        shiny::runApp(appDir, display.mode = "normal")
        return()
}
# [END]
