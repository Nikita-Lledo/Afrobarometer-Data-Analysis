x <- readRDS(file = "data/d_2018.rds")


library(shiny)
library(shinythemes)
library(tidyverse)

# Define server logic required to draw a histogram


shinyServer(function(input, output) {

    output$news <- renderPlot({
        
        news <-  x %>%
            select(Q12A, Q12B, Q12C, Q12D, Q12E)
        
        news_pivot <- news %>%
            pivot_longer(cols = c(Q12A, Q12B, Q12C, Q12D, Q12E),
                         names_to = "news_source",
                         values_to = "frequency") %>%
            group_by(news_source) %>%
            drop_na() %>%
            summarize(never = (sum(frequency == "Never")/n())*100, 
                      less_once = (sum(frequency == "Less than once a month")/n())*100, 
                      few_month = (sum(frequency == "A few times a month")/n())*100,
                      few_week = (sum(frequency =="A few times a week")/n())*100,
                      every = (sum(frequency == "Every day")/n())*100, 
                      .groups = "drop") 
        
        news_final <- news_pivot %>%
            pivot_longer(cols = c(never, less_once, few_month, few_week, every),
                         names_to = "freq_name",
                         values_to = "freq_num") %>%
            group_by(news_source)
        
        news_final %>%
            ggplot(mapping = aes(x = freq_name, y = freq_num, fill = news_source)) +
            geom_col(position = "dodge") +
            labs(title = "Percentage of all respondants and the frequency of which the 
                engage various media sources",
                 x = "Frequency",
                 y = "Percentage of Respondants (%)") +
            scale_fill_manual(name = "News Source", 
                              labels = c("Radio", "Television", "Newspaper", "Internet",
                                         "Social Media"),
                              values = c("blue", "green", "red", "orange", "pink")) +
            scale_x_discrete(labels = c("Every day",
                                        "A few times \n a month",
                                        "A few times \n a week",
                                        "Less than once \n a month",
                                        "Never")) +
            theme_bw()

    })

})


