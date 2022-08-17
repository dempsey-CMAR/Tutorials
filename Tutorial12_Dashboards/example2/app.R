# October 26, 2021

# My second shiny app

# load the package
library(shiny)

# tell it what to say
ui <- fluidPage(
  
  selectInput("dataset", label = "Dataset", choices = ls("package:datasets")),
  
  verbatimTextOutput("summary"),
  tableOutput("table")
  
)

# tell it how to say it
server <- function(input, output, session) {
  
  output$summary <- renderPrint({
    
    dataset <- get(input$dataset, "package:datasets")
    summary(dataset)
    
  })
  
  output$table <- renderTable({
    
    dataset <- get(input$dataset, "package:datasets")
    dataset
    
  })
}

# say it
shinyApp(ui, server)



# NOTE: datasets is a built-in package with different example datasets
# see library(help = "datasets")
# can have ui OR server first




