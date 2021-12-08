library(shiny)
source("../../R/plotCorrByCutoff.R")
load("../../data/deg_df.rda")

ui <- fluidPage(
        titlePanel("Plot Correlation by Cut Off"),

        sidebarLayout(
                sidebarPanel(
                        helpText("Create a plot displaying the result of running corrDEG with different cutoff levels for log 2 FC"),

                        selectInput(inputId = "var",
                                    label = "Specify how you want to plot correlation:",
                                    choices = list("By Cluster",
                                                   "Not By Cluster"),
                                    selected = "By Cluster"),

                        sliderInput(inputId = "num",
                                    label = "Granularity",
                                    value = 5, min = 1, max = 100),
                ),


                mainPanel(plotOutput("CUTOFF"))
        )
)

server <- function(input, output) {
        output$CUTOFF <- renderPlot({
                data <- switch(input$var,
                               "By Cluster" = T,
                               "Not By Cluster" = F)

                plotCorrByCutoff <- plotCorrByCutoff (
                        DEG_df = deg_df,
                        granularity = input$num,
                        byCluster= data)

                print(plotCorrByCutoff)

        })
}
shiny::shinyApp(ui = ui, server = server)
# [END]
