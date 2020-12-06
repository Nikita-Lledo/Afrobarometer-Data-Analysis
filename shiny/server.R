# Server File 
# Here we are calling the necessary rds files that we saved in from our 
# gather.rmd

x <- readRDS(file = "data/direction.rds")
y <- readRDS(file = "data/joined_data.rds")
world <- readRDS(file = "data/world.rds")
cloud <- readRDS(file = "data/wordcloud.rds")
direction <- readRDS(file = "data/direction_year_data.rds")
tbl_2018 <- readRDS(file = "data/tbl_2018.rds")
tbl_2013 <- readRDS(file = "data/tbl_2013.rds")
sent_2018 <- readRDS(file = "data/sent_tot_2018.rds")
sent_2013 <- readRDS(file = "data/sent_tot_2013.rds")
stan <- readRDS(file = "data/joined_data_stan.rds")

# Loading the necessary libraries. 

library(tidyverse)
library(readxl)
library(ggthemes)
library(sf)
library(ggplot2)
library(rnaturalearth)
library(rnaturalearthdata)
library(rgeos)
library(leaflet)
library(htmltools)
library(maptools)
library(janitor)
library(rstanarm)
library(rgdal)
library(viridis)
library(gtsummary)
library(broom.mixed)
library(gt)
library(wordcloud2)

# Creating the plots, tables, graphs and leaflets that will be outputted. 

shinyServer(function(input, output) {

# direction is a graph that does a year 2018 to year 2013 aggregate continent 
# comparison of the percentage of people who thought their respective country 
# was going in the right direction vs the wrong direction in the user selects 
# year. If the user selects a specific year i.e. 2018 or 2013 then a country 
# by country graph showing the percentage of respondents thinking the country 
# is going in the wrong direction vs the right direction is shown. Hence the 
# nested if else statement. 
      
    output$direction <- renderPlot({
        if(input$plotInput == "year") {
            direction %>%
                ggplot(mapping = aes(x = year, 
                                     y = dirc_tot, 
                                     fill = direction)) +
                geom_bar(stat = "identity") +
                geom_hline(yintercept = 0) +
                theme_bw() +
                ylim(-75, 75) +
                coord_flip() +
                scale_fill_manual(values = c("steelblue", 
                                             "lightsteelblue")) +
                labs(title = "Direction in which repspondents 
                     believe the country is going",
                     x = "year",
                     y = "percent of respondents")
        } else {
            if(input$plotInput == "2018"){
                x %>%
                    filter(year == 2018) %>%
                    ggplot(mapping = aes(x = country_code, 
                                         y = direction_value, 
                                         fill = direction)) +
                    geom_bar(stat = "identity") +
                    geom_hline(yintercept = 0) +
                    theme_bw() +
                    ylim(-90, 90) +
                    coord_flip() +
                    scale_fill_manual(values = c("steelblue", 
                                                 "lightsteelblue")) +
                    labs(title = "Direction in which repspondents 
                         believe the country is going",
                         x = "country",
                         y = "percent of respondents") }
            else {
                x %>%
                    filter(year == 2013) %>%
                    ggplot(mapping = aes(x = country_code, 
                                         y = direction_value, 
                                         fill = direction)) +
                    geom_bar(stat = "identity") +
                    geom_hline(yintercept = 0) +
                    theme_bw() +
                    ylim(-90, 90) +
                    coord_flip() +
                    scale_fill_manual(values = c("steelblue", 
                                                 "lightsteelblue")) +
                    labs(title = "Direction in which repspondents
                         believe the country is going",
                         x = "country",
                         y = "percent of respondents")             
            
        } }
        
        
    })
    
# Creating a leaflet with relevant information about each country in the data.
    
  output$map <- renderLeaflet({
      pal <- colorNumeric(palette = "Blues",
                          domain = world$direction_tot)
      leaflet(world) %>%
          setView(lng = 10.0383, lat = 5.7587, zoom = 2.25) %>%
          addProviderTiles("CartoDB.Positron") %>%
          addPolygons(popup = paste("Country:", world$country_name, "<br>",
                                    "Population:", world$population, "<br>",
                                    "GDP:", round(world$gdp, digits = 2)),
                       stroke = FALSE, smoothFactor = 0.2, fillOpacity = 1,
                       color = ~pal(direction_tot)) %>%
          addLegend("bottomright", pal = pal, values = ~direction_tot,
                    title = "Direction (2018)",
                    opacity = 1)
    })
  
# displaying the table of the regression analysis for 2018.  
  
  output$tbl_2018 <- render_gt ({
      tbl_2018
  })

# displaying the table for the regression analysis of 2013. 
  
  output$tbl_2013 <- render_gt ({
      tbl_2013
  })  
  
# displaying the regressional analysis for a user selected country and year.  
  
  output$regression_country <- render_gt ({
      dirc_eco <- stan_glm(formula = direction_country ~ current_eco + 
                             looking_back + looking_ahead +
                           urban + current_living + comp_living, 
                           data = stan %>% filter(country_code == input$reg_country 
                                                  & year == input$reg_year),
                           family = binomial,
                           refresh = 0)
      tbl_dirc <- tbl_regression(dirc_eco) %>%
          as_gt() %>%
          tab_header(title = "Regression of belief of the Direction 
                     in which the country is going",
                     subtitle= "The Effect of different 
                     variables on Direction") %>%
          tab_source_note("Afrobarometer") 
  })
 
# Displaying a wordcloud of the issues that were the top three most important
# issues to respondents in 2018. 
  
  output$wc_2018 <- renderWordcloud2 ({
    wordcloud2(sent_2018, minRotation = -pi/6, maxRotation = -pi/6,
               rotateRatio = 1)
  })
  
# Displaying a wordcloud of the issues that were the top three most important
# issues to respondents in 2013. 
  
  output$wc_2013 <- renderWordcloud2({
    wordcloud2(sent_2013, minRotation = pi/6, maxRotation = pi/6,
               rotateRatio = 1)
    
  })
  
      
})







