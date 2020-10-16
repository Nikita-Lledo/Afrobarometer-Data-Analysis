library(shiny)
library(shinythemes)
library(tidyverse)

# Define server logic required to draw a histogram


shinyServer(function(input, output) {

    output$cars_plot <- renderPlot({

        ggplot(data = mtcars, mapping = aes(x = cyl, y = mpg)) +
            geom_point()

    })

})


