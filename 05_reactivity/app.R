library(shiny)
# Define UI for application
ui <- fluidPage(
  
  "Hello world",
  
  selectInput(inputId = "select_data", 
              label = "Select data set", 
              choices = data(package = "datasets")$results[,3]),
  
  dataTableOutput(outputId = "table_id"),
  plotOutput(outputId = "plot_id"),
  downloadButton(outputId = "download_table_id", label = "Download Table"),
  downloadButton(outputId = "download_plot_id", label = "Download Plot")
  
)
# Define server logic
server <- function(input, output) {
  
  selected_data <- reactive({
    as.data.frame(get(input$select_data))
  })

  #this would not work:
  #selected_data <- as.data.frame(get(input$select_data))
  #Error: ... Operation not allowed without an active reactive context. 
  #(You tried to do something that can only be done from inside a reactive expression or observer.)
  
  output$table_id <- renderDataTable({
    selected_data()
  })
  
  output$plot_id <- renderPlot({

    if(ncol(selected_data()) < 2){
      return(NULL)
    }else{
      plot(selected_data()[,1:2])
    }
  })
  
  output$download_table_id <- downloadHandler(
    filename = function(){ 
      paste(input$select_data, '.csv', sep='') 
    },
    content = function(file){
      write.csv(selected_data(), file)
    }
  )
  
  output$download_plot_id <- downloadHandler(
    
    filename = function(){
      paste(input$select_data, '.pdf', sep='')
    },
    content = function(file){
      pdf(file)
      plot(selected_data()[,1:2])
      dev.off()
    })
}
# Run the application 
shinyApp(ui = ui, server = server)