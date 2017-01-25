library(shiny)
library(ggplot2)
library(data.table)
#write.csv(iris, "iris.csv", row.names = FALSE)
# Define UI for application
ui <- fluidPage(
  # Copy the line below to make a file upload manager
  fileInput(inputId = "upload_file_id", label = "File input"),
  #define a text output that displays the return of fileInput() function
  verbatimTextOutput(outputId = "output_text_id"),
  #define an interactive table of the uploaded data set
  dataTableOutput(outputId = "output_table_id")
)
# Define server logic
server <- function(input, output) {
  # You can access the value of the fileInput() function with input$output_text_id
  output$output_text_id <- renderPrint({
    str(input$upload_file_id)
  })
  output$output_table_id <- renderDataTable({
    if(is.null(input$upload_file_id)){return(NULL)}else{
      uploaded_data <- fread(input$upload_file_id[1, 4])}
  }, options = list(lengthChange = TRUE))
}
# Run the application 
shinyApp(ui = ui, server = server)