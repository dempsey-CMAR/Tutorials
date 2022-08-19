# October 26, 2021

# My first shiny app

# A shiny app consists of a ui (user interface) and a server.
# This basic app has no input or output, and merely displays "Hello, world!"

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
