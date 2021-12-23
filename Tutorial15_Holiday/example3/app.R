# December 23, 2021

# Holiday Card
# Modified from: https://www.r-craft.org/r-news/christmas-tree-with-ggplot/

# load the package
library(here)
library(ggplot2)
library(glue)
library(readr)
library(shiny)

# import greeting options 
greet <- read_csv(here("greetings.csv"))
# source tree function
source(here("generate_christmas_tree.R"))

# tell it what to say
ui <- fluidPage(
  
  titlePanel("Generate Christmas Card"),
  
  sidebarPanel(
    selectInput("greeting", label = "Choose holiday greeting", 
                choices = greet$GREETING),
    
    textInput("to", label = "Enter name of recipient:", value = ""),
    textInput("from", label = "Enter your name:", value = ""),
    
    numericInput("dec_seed", value = 0, label = "Enter random seed:"),
    
    downloadButton('downloadPlot', 'Download Card')
  ),
  
  mainPanel(plotOutput("tree"))
  
)

# tell it how to say it
server <- function(input, output, session) {
  
  # make the card based on the inputs
  tree_plot <- reactive({
    
    message <- input$greeting
    address <- glue("To: {input$to} \nFrom: {input$from}")
    
    seed <- input$dec_seed
    
    generate_christmast_tree(seed, message, address)
    
  })
  
  # output object that will be displayed by ui
  output$tree <- renderPlot({
    
    tree_plot()
    
  })
  
  # download the card
  output$downloadPlot <- downloadHandler(
    filename = function() { "greeting_card.png" },
    content = function(file) {
      device <- function(..., width, height) grDevices::png(..., width = width, height = height, res = 300, units = "in")
      ggsave(file, plot = tree_plot(), device = device)
    }
  )
  
}

# say it
shinyApp(ui, server)






