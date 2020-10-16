x <- readRDS(file = "data/d_2018.rds")


library(shiny)
library(shinythemes)
library(tidyverse)

# Define server logic required to draw a histogram


shinyServer(function(input, output) {

    output$location <- renderPlot({
        
        x %>%
        group_by(country) %>%
        summarize(num_res = n()) %>%
        
        ggplot(mapping = aes(x = country, y = num_res)) +
        geom_col() +
        labs(title = "The number of respondents per country that participated")
        

    })

})


