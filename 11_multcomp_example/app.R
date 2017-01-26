library(shiny)
library(multcomp)
library(shiny)
library(shinydashboard)
library(ggplot2)
library(plotly)
library(dplyr)
library(broom)

ui <- dashboardPage(
  
  dashboardHeader(title = "Externe Datensätze hochladen"),
  
  dashboardSidebar(
    selectInput(inputId = "select_data", 
                label = "Select data set", 
                choices = data(package = "multcomp")$results[,3]),
    selectInput(inputId = "select_x_variable", 
                label = "Select X Variable (factor)", 
                choices = ""),
    selectInput(inputId = "select_y_variable", 
                label = "Select Y Variable (numeric)",
                choices = "")
  ),
  
  dashboardBody(
    tabsetPanel(
      tabPanel(title = "Table",
               dataTableOutput(outputId = "table_id")),
      tabPanel(title = "Plot",
               plotlyOutput(outputId = "plot_id")),
      tabPanel(title = "Results",
               h3("Calculating a linear model of the form",
                  br(),
                  code("lm(numeric variable ~ factor variable -1, data = selected data)"),
                  br(),
                  "and perform multiple comparisons for parameters of that model."),
               selectInput(inputId = "select_contr_mat", 
                           label = "Select Type of Contrast Matrix",
                           choices = c("Dunnett", "Tukey", "Sequen", "AVE", 
                                       "Changepoint", "Williams", "Marcus", 
                                       "McDermott", "UmbrellaWilliams", "GrandMean")),
               tableOutput (outputId = "results_id")))
    )
  )

server <- function(input, output, session) { 
  
  selected_data <- reactive({
    as.data.frame(get(input$select_data))
  })
  
  observe({
    updateSelectInput(session = session,
                      inputId = "select_x_variable",
                      choices = colnames(selected_data()),
                      selected = colnames(selected_data())[1])
    updateSelectInput(session = session,
                      inputId = "select_y_variable",
                      choices = colnames(selected_data()),
                      selected = colnames(selected_data())[2])
  })
  
  output$table_id <- renderDataTable({
    selected_data()
  })
  
  output$plot_id <- renderPlotly({
    
    p <- ggplot(data = selected_data(), aes_string(x = input$select_x_variable,
                                        y = input$select_y_variable))
    p + geom_boxplot() + geom_jitter(width = 0.1, height = 0)
  })
  
  results_glht <- reactive({
    fm1 <- lm(paste0(input$select_y_variable, " ~ ", input$select_x_variable, "-1"), data = selected_data())
    n <- selected_data() %>%
      dplyr::group_by_(input$select_x_variable) %>%
      dplyr::summarise(N = n()) %>%
      dplyr::ungroup() %>%
      data.frame() 
    K <- contrMat(n = n$N, type = input$select_contr_mat)
    results_mult_comp <- glht(fm1, linfct = K)
    summary_mult_comp <- summary(results_mult_comp)
    summary_mult_comp
  })
  
  output$results_id <- renderTable({
    tidy(results_glht())
  })

  
}

shinyApp(ui, server)
