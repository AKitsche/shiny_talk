library(shiny)
# Define UI for application
ui <- fluidPage(
  titlePanel(title = "Example App"),
  sidebarLayout(
    sidebarPanel(
      selectInput(inputId = "select_data", 
                  label = "Select data set", 
                  choices = data(package = "datasets")$results[,3]),
      downloadButton(outputId = "download_table_id",
                     label = "Download Table"),
      downloadButton(outputId = "download_plot_id",
                     label = "Download Plot")
    ),
    mainPanel(
      tabsetPanel(
        tabPanel(
          title = "Table",
          dataTableOutput(outputId = "table_id")
        ),
        tabPanel(
          title = "Plot",
          plotOutput(outputId = "plot_id")
        )
      )
    )
  )
)
# Define server logic
server <- function(input, output) {
  
  output$table_id <- renderDataTable({
    as.data.frame(get(input$select_data))
  })
  
  output$plot_id <- renderPlot({
    data_tmp <- as.data.frame(get(input$select_data))
    if(ncol(data_tmp) < 2){
      return(NULL)
    }else{
      plot(data_tmp[,1:2])
    }
  })
  
  output$download_table_id <- downloadHandler(
    
    filename = function(){ 
      paste(input$select_data, '.csv', sep='') 
    },
    
    content = function(file){
      
      write.csv(as.data.frame(get(input$select_data)), file)
    }
  )
  
  output$download_plot_id <- downloadHandler(
    
    filename = function(){ 
      paste(input$select_data, '.pdf', sep='') 
    },
    
    content = function(file){
      pdf(file)
      plot(as.data.frame(get(input$select_data))[,1:2])
      dev.off()
    }
  )
  
}
# Run the application 
shinyApp(ui = ui, server = server)
