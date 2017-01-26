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
  #plotlyOutput(outputId = "iris_scatterplot")
  plotOutput(outputId = "iris_scatterplot",
             click = "plot_click",
             dblclick = "plot_dblclick",
             hover = "plot_hover",
             brush = "plot_brush"),
  verbatimTextOutput(outputId = "plot_info")
)
# Define server logic
server <- function(input, output) {
  
  output$iris_scatterplot <- renderPlot({
    p <- ggplot(data = iris, aes_string(x = input$input_x_variable,
                                        y = input$input_y_variable))
    p + geom_point(aes(color = Species))
  })
  
  output$plot_info <- renderText({
    
    xy_str <- function(e) {
      if(is.null(e)) return("NULL\n")
      paste0("x=", round(e$x, 1), " y=", round(e$y, 1), "\n")
    }
    xy_range_str <- function(e) {
      if(is.null(e)) return("NULL\n")
      paste0("xmin=", round(e$xmin, 1), " xmax=", round(e$xmax, 1), 
             " ymin=", round(e$ymin, 1), " ymax=", round(e$ymax, 1))
    }
    
    paste0(
      "click: ", xy_str(input$plot_click),
      "dblclick: ", xy_str(input$plot_dblclick),
      "hover: ", xy_str(input$plot_hover),
      "brush: ", xy_range_str(input$plot_brush)
    )
  })
}
# Run the application 
shinyApp(ui = ui, server = server)