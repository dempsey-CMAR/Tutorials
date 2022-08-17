# October 26, 2021

# My first shiny app

# load the package
library(shiny)

# tell it what to say
ui <- fluidPage(
  "Hello, world!"
)

# tell it how to say it
server <- function(input, output, session) {
  
}

# say it
shinyApp(ui, server)
