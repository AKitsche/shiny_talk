library(shiny)
library(ggplot2)
# Define UI for application
ui <- fluidPage(
  "Iris data set",
  selectInput(inputId = "input_x_variable", 
              label = "X Variable", 
              choices = colnames(iris), 
              selected = colnames(iris)[1], 
              multiple = FALSE),
  selectInput(inputId = "input_y_variable", 
              label = "Y Variable", 
              choices = colnames(iris), 
              selected = colnames(iris)[2], 
              multiple = FALSE),
  plotOutput(outputId = "iris_scatterplot")
)
# Define server logic
server <- function(input, output) {
  
  output$iris_scatterplot <- renderPlot({
    
    p <- ggplot(data = iris, aes_string(x = input$input_x_variable,
                                        y = input$input_y_variable))
    p + geom_point(aes(color = Species))
  })
}
# Run the application 
shinyApp(ui = ui, server = server)