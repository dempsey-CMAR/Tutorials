library(here)
library(quarto)

card_template <- paste0("Tutorial 16_Quarto/part3/holiday_card_generic.qmd")

to <- c("Kiersten", "Nicole", "Raeleigh", "Ryan", "Leah")

# Because of the way the Tutorials project is set up, the cards will be 
# exported to the Tutorials folder
sapply(to, function(x) { 
  
  quarto_render(
    input = card_template, 
    output_file = paste0(x, "_card.pdf"),
    execute_params = list(to = x, from = "Danielle"))
  
})






