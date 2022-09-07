# December 23, 2021

# Holiday Card
# Modified from: https://www.r-craft.org/r-news/christmas-tree-with-ggplot/

# load the package
library(here)
library(ggplot2)
library(glue)
library(readr)
library(shiny)

path <- paste0(here(), "/Tutorial14_Holiday Dashboard/example3")
# import greeting options 
greet <- read_csv(paste0(path, "/greetings.csv"))
# source tree function
source(paste0(path, "/generate_christmas_tree.R"))


# tell it what to say
ui <- fluidPage(
  
  titlePanel("Generate Christmas Card"),
  
  sidebarPanel(
    selectInput("greeting", label = "Choose holiday greeting", 
                choices = sort(greet$GREETING)),
    
    textInput("to", label = "Enter name of recipient:", value = ""),
    textInput("from", label = "Enter your name:", value = ""),
    textInput("note", label = "Enter your message:", value = ""),
    
    numericInput("dec_seed", value = 678, label = "Enter number to randomly place decorations:"),
    
    downloadButton('downloadPlot', 'Download Card')
  ),
  
  mainPanel(plotOutput("tree", width = "70%"))
  
)

# tell it how to say it
server <- function(input, output, session) {
  
  # make the card based on the inputs
  tree_plot <- reactive({
    
    message <- input$greeting
    address <- glue("To: {input$to} \nFrom: {input$from} \n{input$note}")
    
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






