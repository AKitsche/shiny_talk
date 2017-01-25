library(shiny)
# Define UI for application
ui <- fluidPage(
  
  #use html content
  HTML("
    <h1>Ein Beispiel für Header</h1>
       <p>Ein Beispiel für Paragraph</p>
       "),
  
  #use tags
  tags$p("Dies ist eine Beispiel", 
         tags$a(href = "https://shiny.rstudio.com/", "Shiny"), 
         "App."),
  #use simple functions for constructing HTML documents
  #use simple functions for constructing HTML documents
  p("Es ist einfach GUI mit", 
    a(href = "https://cran.r-project.org/", "R"),
    code("Code"),
    em("zu"),
    strong("erstellen")) 
)
# Define server logic
server <- function(input, output) {}
shinyApp(ui = ui, server = server)