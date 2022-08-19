# December 23, 2021

# Holiday Card
# Modified from: https://www.r-craft.org/r-news/christmas-tree-with-ggplot/

# load the package
library(here)
library(ggplot2)
library(glue)
library(readr)
library(shiny)

path <- paste0(here(), "/Tutorial14_Holiday Dashboard/example2")
greet <- read_csv(paste0(path, "/greetings.csv"))
source(paste0(path, "/generate_christmas_tree.R"))

# tell it what to say
ui <- fluidPage(
  
    sidebarPanel(
      selectInput("greeting", label = "Choose holiday greeting", 
                  choices = greet$GREETING),
      
      textInput("to", label = "Enter name of recipient:", value = ""),
      textInput("from", label = "Enter your name:", value = ""),
      
      numericInput("dec_seed", value = 0, label = "Enter random seed:"),
    ),
    
    mainPanel(plotOutput("tree"))
  
)

# tell it how to say it
server <- function(input, output, session) {
  
  output$tree <- renderPlot({
    
    message <- input$greeting
    address <- glue("To: {input$to} \nFrom: {input$from}")
    
    seed <- input$dec_seed
    
    generate_christmast_tree(seed, message, address)
    
  })
  
}

# say it
shinyApp(ui, server)






