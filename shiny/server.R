x <- readRDS(file = "data/direction.rds")
y <- readRDS(file = "data/joined_data.rds")
world <- readRDS(file = "data/world.rds")


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

# Define server logic required to draw a histogram


shinyServer(function(input, output) {
    
    output$direction <- renderPlot({
        if(input$plotInput == "year") {
            direction_year_data <- x %>%
                group_by(direction, year) %>%
                mutate(dirc_tot = sum(direction_value)/n()) %>%
                select(year, dirc_tot, direction) %>%
                unique() 
            
            direction_year_data %>%
                ggplot(mapping = aes(x = year, y = dirc_tot, fill = direction)) +
                geom_bar(stat = "identity") +
                geom_hline(yintercept = 0) +
                theme_bw() +
                ylim(-75, 75) +
                coord_flip() +
                scale_fill_manual(values = c("steelblue", "lightsteelblue")) +
                labs(title = "Direction in which repspondents believe the country is going",
                     x = "year",
                     y = "percent of respondents")
        } else {
            if(input$plotInput == "2018"){
                x %>%
                    filter(year == 2018) %>%
                    ggplot(mapping = aes(x = country_code, y = direction_value, fill = direction)) +
                    geom_bar(stat = "identity") +
                    geom_hline(yintercept = 0) +
                    theme_bw() +
                    ylim(-90, 90) +
                    coord_flip() +
                    scale_fill_manual(values = c("steelblue", "lightsteelblue")) +
                    labs(title = "Direction in which repspondents believe the country is going",
                         x = "country",
                         y = "percent of respondents") }
            else {
                x %>%
                    filter(year == 2013) %>%
                    ggplot(mapping = aes(x = country_code, y = direction_value, fill = direction)) +
                    geom_bar(stat = "identity") +
                    geom_hline(yintercept = 0) +
                    theme_bw() +
                    ylim(-90, 90) +
                    coord_flip() +
                    scale_fill_manual(values = c("steelblue", "lightsteelblue")) +
                    labs(title = "Direction in which repspondents believe the country is going",
                         x = "country",
                         y = "percent of respondents")             
            
        } }
        
        
    })
    

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
  
  output$tbl_2018 <- render_gt ({
      dirc_2018 <- stan_glm(formula = direction_country ~ current_eco + looking_back + looking_ahead +
                            urban + current_living + comp_living, 
                            data = y %>% filter(year == 2018),
                            refresh = 0)
      
      tbl_regression(dirc_2018) %>%
          as_gt() %>%
          tab_header(title = "Regression of belief of the Direction in which the country is going 2018",
                     subtitle= "The Effect of different variables on Direction") %>%
          tab_source_note("Afrobarometer") 
      
  })

  output$tbl_2013 <- render_gt ({
      dirc_2013 <- stan_glm(formula = direction_country ~ current_eco + looking_back + looking_ahead +
                            urban + current_living + comp_living, 
                            data = y %>% filter(year == 2013),
                            refresh = 0)
      
      tbl_regression(dirc_2013) %>%
          as_gt() %>%
          tab_header(title = "Regression of belief of the Direction in which the country is going 2013",
                     subtitle= "The Effect of different variables on Direction") %>%
          tab_source_note("Afrobarometer") 
      
  })  
  
  output$regression_country <- render_gt ({
      dirc_eco <- stan_glm(formula = direction_country ~ current_eco + looking_back + looking_ahead +
                           urban + current_living + comp_living, 
                           data = y %>% filter(country_code == input$reg_country & year == input$reg_year),
                           refresh = 0)
      tbl_dirc <- tbl_regression(dirc_eco) %>%
          as_gt() %>%
          tab_header(title = "Regression of belief of the Direction in which the country is going",
                     subtitle= "The Effect of different variables on Direction") %>%
          tab_source_note("Afrobarometer") 
  })
      
     
      
    
})






