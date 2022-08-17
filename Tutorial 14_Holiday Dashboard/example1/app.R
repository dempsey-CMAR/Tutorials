# December 23, 2021

# Holiday Card
# Modified from: https://www.r-craft.org/r-news/christmas-tree-with-ggplot/

# load the package
library(here)
library(ggplot2)
library(readr)
library(shiny)

path <- paste0(here(), "/Tutorial 14_Holiday Dashboard/example1")
greet <- read_csv(paste0(path, "/greetings.csv"))
source(paste0(path, "/generate_christmas_tree.R"))


# tell it what to say
ui <- fluidPage(
  
  selectInput("greeting", label = "Choose holiday greeting", 
              choices = greet$GREETING),
  
  numericInput("dec_seed", value = 0, label = "Enter random seed:"),
  
  plotOutput("tree")

)

# tell it how to say it
server <- function(input, output, session) {

  output$tree <- renderPlot({

    message <- input$greeting
    
    seed <- input$dec_seed
    
    generate_christmast_tree(seed, message)

  })

}

# say it
shinyApp(ui, server)






