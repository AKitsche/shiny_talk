library(shiny)
library(shinydashboard)
library(ggplot2)

ui <- dashboardPage(
  dashboardHeader( title = "Externe Datensätze hochladen"),
  dashboardSidebar(
    selectInput(inputId = "input_x_variable", 
                label = "X Variable", 
                choices = colnames(iris), 
                selected = colnames(iris)[1], 
                multiple = FALSE),
    selectInput(inputId = "input_y_variable", 
                label = "Y Variable", 
                choices = colnames(iris), 
                selected = colnames(iris)[2], 
                multiple = FALSE)
  ),
  dashboardBody(
    plotOutput(outputId = "iris_scatterplot")
  )
)

server <- function(input, output) { 
  
  output$iris_scatterplot <- renderPlot({
    
    p <- ggplot(data = iris, aes_string(x = input$input_x_variable,
                                        y = input$input_y_variable))
    p + geom_point(aes(color = Species))
    })
  }

shinyApp(ui, server)