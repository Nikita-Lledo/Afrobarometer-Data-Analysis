# This is the user-interface definition of a Shiny web application. You can

# Loading the necessary libraries. 

library(shiny)
library(shinythemes)
library(tidyverse)
library(DT)
library(leaflet)
library(lubridate)
library(stats)
library(dplyr)
library(gt)
library(wordcloud2)

# selecting the theme and the title of my project

shinyUI(
  navbarPage(theme = shinytheme("yeti"),
             "Afrobarometer",
             
###### FIRST PAGE ###########

# The first page gives background information. I use fluid page and fluid row
# to organize my output into a 2x2 grid for user experience. 
# I am allowing the user to select their input for the graph they would like to 
# view for the direction of the country. I am also displaying a leaflet with 
# relevant information for each country. 
             
             tabPanel(align = "center", "The Direction We Are Heading",
                      h2("Democracy and Africa: What Direction are we heading?"),
                      p("Since the end of colonialization and the rise of globalization, the African continent as a whole has found itself in a precarious situation with limited resources yet with countries having the fastest growing populations both historically and worldwide today. 
                        Imagery surrounding Africa has ranged from “Heart of Darkness” to “Noble Savage.” 
                        Historically, scholars have looked at Africa from the outside whereby the African continent are characterized as ‘informal’, ‘developing’, the ‘Global South’. 
                        However, Nigeria, for example, has decided to take development and perspectives of development into their own hands, self-proclaiming Lagos as the 'Big Apple of Africa.' 
                        This begs to question, what do citizens on the African continent think about the direction in which their respective country is moving?), 
                        This project explores the direction in which African citizens believe their respective country is going – bringing levels and paths of development back to the ground. 
                        By showing what factors influence the direction in which one thinks their country is going, this project begins to unpack local sentiment toward development, illuminating greater understanding and potential action. 
                        This project serves as foundational work for my senior thesis on Democracy and Development in developing nations."
                      ),
                      br(),
                      br(),
                      br(),
                      fluidPage(
                        fluidRow(column(6,
                                        h3("People are Less Optimistic"),
                                        p("As the graph on the left shows, between 2013 and 2018 the percentage of people on the African continent who believe their country is heading in the wrong direction has increased.
                                          If we compare the two graphs that offer a country breakdown per year of sentiment toward the direction of development of each country, there seems a general shift toward the 'wrong direction'.
                                          This shift of people toward believing that the country is going in the wrong direction is most notable in Niger, Namibia and Zambia.
                                          Interestingly, Kenya and Uganda do not follow this trend, with more than 10% increase from 2013 to 2018 people believing that the country is going in the right direction.
                                          Select from the drop down box, the graph you would like to view."
                                        )),
                                 column(6,
                                        selectInput("plotInput", 
                                                    label = "What would you like to view",
                                                    choices = c("Year comparison" = "year",
                                                                "2018 country comparison" = "2018",
                                                                "2013 country comparison" = "2013"),
                                                    selected = "Year"),
                                        plotOutput("direction")
                                 )),
                        br(),
                        br(),
                        br(),
                        fluidRow(column(6,
                                        leafletOutput("map", 
                                                      height = 700)
                                        ),
                                 column(6,
                                        h3("taking a closer look at Africa"),
                                        p("As we can see from the map on the right, the percentage of respondents that believe their country is going in one direction or the other varies across the continent.
                                           However, no entire nation believes they are going in the right direction.
                                           The scale of backward to forward is 0 to 1 with lower numbers representing a higher percentage of the population who believe  the country is moving in the wrong direction.
                                           Click on the various countries in Africa to view additional information about the country."
                                          ),
                                        )))),


##### SECOND PAGE ######

# the second page gives an analysis and the results of a regression model for 
# modelling the direction of the country. I do analysis and show the results for 
# the aggreate of 2018 and 2013. I allow the user to then select the year and 
# the country they would like to view results specfically for. 

             tabPanel(align = "center", "Modelling Direction",
                      h2("Modelling Direction"),
                      p("Here, we are modelling the direction in which people think their respective country is going as a function of multiple economic and livelihood factors.
                        Direction is a binary variable where 0 is the 'wrong direction' and 1 is the 'right direction'.
                        Because this is binary data we run a binominal regression. In the write up for each I show the convertion of the log of odds ratio to the odds ratio to intepret each co-efficient. 
                        Each coefficent represents the expected change in log odds for a one-unit increase in the math score. 
                        The odds ratio can be calculated by exponentiating this value.
                        Below I offer some additional information on each variable and then analysis on aggreate data per year.
                        At the bottom of the page you are welcome to explore the data per country and year!"
                      ),
                      h3("Variables in model"),
                      p("In this model we take into account a number of different economic and social variables."),
                      p("Current_eco: on a scale of 1 (very bad) to 5 (very good) participates rated the current state of their country’s economy."), 
                      p("Looking_back: ona scale of 1 (much worse) to 5 (much better) participates rated the state of their country’s economy compared to the previous year."), 
                      p("Looking_ahead: on a scale of 1 (much worse) to 5(much better) participates rated the future economy of the country compared to its current state."), 
                      p("Urban: indicates whether the respondent lives in a urban (1), or rural (2) area."),
                      p("Current_living: on a scale from 1 (very bad) to 5 (very good) respondents rated their current living conditions"), 
                      p("Comp_living: on a scale from 1 (much worse) to 5 (much better) respondents rated their current living conditions compared to the average citizen in their country."
                        ),
                      column(6,
                             wellPanel(
                               h3("2018 Regression model"),
                               gt_output("tbl_2018"),
                               br(),
                               p("This model shows the regression of the direction of the economy on the variables listed above for the year of 2018 continent wide."),
                               p("the odds ratio for current_eco is 1.71 which suggests that we expect to see about a 71% increase in the odds of a respondent believing the country is going in the right direction for a one-unit increase in belief about the current economic condition."),
                               p("the odds ratio for looking_back is 1.29 which suggests that we expect to see about a 29% increase in the odds of a respondent believing the country is going in the right direction for a one-unit increase in belief about the current economic conditions compared to that of 12 months ago."),
                               p("the odds ratio for looking_ahead is 1.47 which suggests that we expect to see about a 47% increase in the odds of a respondent believing the country is going in the right direction for a one-unit increase in their belief of the future economic conditions compared to today."),
                               p("the odds ratio for current_living is 1.08 which suggests that we can expect to see about a 8% increase in the odds of a respondent believing the country is going in the right direction for a one-unit increase in their belief of state of their current living conditions."),
                               p("the odds ratio for comp_living is 1.11 which suggests that we can expect to see about a 11% increase in the odds of a respondent beleiving the country is going in the right direction for a one-unit increase in their belief of the state of their living conditions compared to that of other citizens in their country.")
                               )),
                        column(6,
                               wellPanel(
                                 h3("2013 Regression model"),
                                 gt_output("tbl_2013"),
                                 br(),
                                 p("This model shows the regression of the direction of the economy on the variables listed above for the year of 2018 continent wide."),
                                 p("the odds ratio for current_eco is 1.80 which suggests that we expect to see about a 80% increase in the odds of a respondent believing the country is going in the right direction for a one-unit increase in belief about the current economic condition."),
                                 p("the odds ratio for looking_back is 1.15 which suggests that we expect to see about a 15% increase in the odds of a respondent believing the country is going in the right direction for a one-unit increase in belief about the current economic conditions compared to that of 12 months ago."),
                                 p("the odds ratio for looking_ahead is 1.78 which suggests that we expect to see about a 78% increase in the odds of a respondent believing the country is going in the right direction for a one-unit increase in their belief of the future economic conditions compared to today."),
                                 p("the odds ratio for current_living is 1.07 which suggests that we can expect to see about a 7% increase in the odds of a respondent believing the country is going in the right direction for a one-unit increase in their belief of state of their current living conditions."),
                                 p("the odds ratio for comp_living is 1.17 which suggests that we can expect to see about a 17% increase in the odds of a respondent beleiving the country is going in the right direction for a one-unit increase in their belief of the state of their living conditions compared to that of other citizens in their country.")
                               )),
                        br(),
                      sidebarLayout(
                        sidebarPanel(
                          h3("Run a Regression for each country:"),
                          selectInput("reg_country", 
                                      label = "Country:",
                                      choices = c("South Africa" = "ZAF",
                                                   "Benin, Republic of" = "BEN",
                                                   "Algeria, People's Democratic Republic of" = "DZA",
                                                   "Burkina Faso" = "BFA",
                                                   "Botswana, Republic of"= "BWA",
                                                   "Cameroon, Republic of" = "CMR",
                                                   "Cote d'Ivoire, Republic of" = "CIV",
                                                   "Cape Verde, Republic of" = "CPV",
                                                   "Gabon, Gabonese Republic" = "GAB",
                                                   "Ghana, Republic of" = "GHA",
                                                   "Guinea, Republic of" = "GIN",
                                                   "Kenya, Republic of" = "KEN",
                                                   "Lesotho, Kingdom of" = "LSO",
                                                   "Liberia, Republic of" ="LBR",
                                                   "Madagascar, Republic of"= "MDG",
                                                   "Mauritius, Republic of" = "MUS",
                                                   "Mali, Republic of" = "MLI",
                                                   "Malawi, Republic of" = "MWI",
                                                   "Niger, Republic of" = "NER",
                                                   "Gambia, Republic of the"= "GMB",
                                                   "Morocco, Kingdom of" = "MAR",
                                                   "Mozambique, Republic of" = "MOZ", 
                                                   "Namibia, Republic of" = "NAM",
                                                   "Nigeria, Federal Republic of" = "NGA",
                                                   "Senegal, Republic of" = "SEN",
                                                   "Sierra Leone, Republic of" = "SLE",
                                                   "Sao Tome and Principe, Democratic Republic of" ="STP",
                                                   "Swaziland, Kingdom of" = "SWZ",
                                                   "Tunisia, Tunisian Republic" = "TUN",
                                                   "Uganda, Republic of" = "UGA",
                                                   "Burundi, Republic of" = "BDI",
                                                   "Egypt, Arab Republic of" = "EGY",
                                                   "Zimbabwe, Republic of" = "ZWE",
                                                   "Zambia, Republic of" = "ZMB",
                                                   "Togo, Togolese Republic" = "TGO",
                                                   "Tanzania, United Republic of" = "TZA",
                                                   "Sudan, Republic of" = "SDN"
                                                   ),
                                      selected = "South Africa"),
                          selectInput("reg_year",
                                      label = "year:",
                                      choices = c("2018" = "2018",
                                                  "2013" = "2013"),
                                      selected = "2018")),
                        mainPanel(h3("Regression for selected country and year"),
                                  p("below is the regression for the country and the year that you have chosen to analyze"),
                                  gt_output("regression_country")
                                  ))
                      ),

######## THIRD PAGE #########

# the third page shows two word clouds of the top three most important issues 
# for each respondent across the continent for their respective country. 

             tabPanel(align = "center", "Issues Clouds",
                      h2("Top 3 Important Issue"),
                      p("In the questionaire, respondents were asked to select from 32 different issues what the top three issues facing their respective country were.
                        Here we look at across all respondents on the continent what were the issues that appeared the most in repsonses in both 2018 and 2013.
                        Hover over each issue to see how many respondents placed the issue in the top 3.
                        The bigger the word, quite literally, the bigger the issue.
                        From look at the clouds we can see that corruption, education, health and electricity have consistently been top issues."),
                      fluidPage(
                        fluidRow(column(6,
                                        h3("Most Important issues 2018"),
                                        p("Below are the issues from 2018 that people listed in the top three issues facing the country."),
                                        wordcloud2Output("wc_2018")
                                        ),
                                 column(6,
                                        h3("Most Important issues 2013"),
                                        p("Below are the issues from 2013 that people listed in the top three issues facing the country."),
                                        wordcloud2Output("wc_2013")
                                 )))),

     
######## FOURTH PAGE #########

# the fourth page is an information page. offering information on my self, the 
# data and additional information relevant to the project. 

             tabPanel(align = "center", "About Page", 
                      h2("Background Information"),
                      p("Since the end of colonialization and the rise of globalization, the African continent as a whole has found itself in a precarious situation with limited resources yet with countries having the fastest growing populations both historically and worldwide today. 
                        Imagery surrounding Africa has ranged from “Heart of Darkness” to “Noble Savage.” 
                        Historically, scholars have looked at Africa from the outside whereby the African countries are characterized as ‘informal’, ‘developing’, the ‘Global South’. 
                        However, Nigeria, for example, has decided to take development and perspectives of development into their own hands, self-proclaiming Lagos as the 'Big Apple of Africa.' 
                        This begs to question, what do citizens on the African continent think about the direction in which their respective countries are moving? 
                        This project explores the direction in which African citizens believe their respective countries are going – bringing levels and paths of development back on the ground. 
                        By showing what factors influence the direction in which one thinks their country is going, this project begins to unpack local sentiment toward development, illuminating greater understanding and potential action. 
                        This project serves as foundational work for my senior thesis on Democracy and Development in developing nations."
                      ),
                      p("In order to complete this data was taken from the Afrobarometer study. 
                        The Afrobarometer is a comparative series of public attitude surveys that assess African citizen's attitudes to democracy and governance, markets, and civil society, among other topics. The surveys have been undertaken at periodic intervals since 1999."),
                      br(),
                      p(a("link to my github repo!",  href ="https://github.com/Nikita-Lledo/final-project.git"
                      )),
                      br(),
                      h3("Data Sources"),
                      p("This data project drew from the following publicly available datasets"),
                      a("world bank data on GDP", href = "https://data.worldbank.org/indicator/NY.GDP.MKTP.CD"),
                      br(),
                      a("world bank data on Population", href = "https://data.worldbank.org/indicator/SP.POP.TOTL"),
                      br(),
                      a("Afrobaramete data", href = "https://www.datafirst.uct.ac.za/dataportal/index.php/catalog/AFR"),
                      br(),
                      h3("About Me"),
                      p("Nikita was born and raised in Johannesburg, South Africa. 
                        She is currently a Junior at Harvard College study Government and Social Anthropology with a secondary in Chemistry. 
                        Before she came to Harvard, she took a gap year to further her university debating career, sail in South Africa and just explore her home country. 
                        She has invested her time into building the international community at Harvard and also works as a child patient advocate at Boston's Children's Hospital. 
                        This past summer, she was working for a non-profit organization in Serbia - the Center for Applied Nonviolent Strategies. T
                        his semester, she is a course assistant for Harvard College's Edx Physics course and has just qualified as a yoga instructor. 
                        Nikita loves learning about the world, hiking and scuba diving!"
                        ), 
                       a("nikitalledo@college.harvard.edu", href = "mailto:nikitalledo@college.harvard.edu"),
                       ".")
             )

)