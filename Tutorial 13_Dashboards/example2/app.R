# October 26, 2021

# My second shiny app

# In this app, the input is a drop-down list of R's built-in datasets, and the 
# outputs are a summary and a table of the chosen dataset. The ui sets up these
# elements, and the server handles the interactivity.

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




