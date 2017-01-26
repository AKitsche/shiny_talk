library(shiny)
library(ggplot2)
library(plotly)
library(metricsgraphics)
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
  #plotlyOutput(outputId = "iris_scatterplot")
  metricsgraphicsOutput(outputId = "iris_scatterplot")
)
# Define server logic
server <- function(input, output) {
  
  output$iris_scatterplot <- renderMetricsgraphics({
  # output$iris_scatterplot <- renderPlotly({
    # p <- ggplot(data = iris, aes_string(x = input$input_x_variable,
    #                                     y = input$input_y_variable))
    # p + geom_point(aes(color = Species))
    iris %>%
      mjs_plot(x=input$input_x_variable, 
               y=input$input_y_variable) %>%
      mjs_point(color_accessor=Species,
                x_rug=TRUE, y_rug=TRUE)
  })
}
# Run the application 
shinyApp(ui = ui, server = server)