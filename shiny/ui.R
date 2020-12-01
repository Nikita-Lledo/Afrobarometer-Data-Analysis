#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#


library(shiny)
library(shinythemes)
library(tidyverse)
library(DT)
library(leaflet)
library(lubridate)
library(stats)
library(dplyr)
library(gt)


shinyUI(
    navbarPage(theme = shinytheme("yeti"), 
               "Afrobarometer",
               
               tabPanel(align = "center", "The Direction We Are Heading", 
                   h2("Democracy and Africa: What Direction are we heading?"),
                   p("Since the end of colonialization and the rise of globalization, the African continent as a whole has found itself in a precarious situation with limited resources yet with countries having the fastest growing populations both historically and worldwide today. 
                      Imagery surrounding Africa has ranged from “Heart of Darkness” to “Noble Savage.” 
                      Historically, scholars have looked at Africa from the outside whereby the African countries are characterized as ‘informal’, ‘developing’, the ‘Global South’. 
                      However, Nigeria, for example, has decided to take development and perspectives of development into their own hands, self-proclaiming Lagos as the 'Big Apple of Africa.' 
                      This begs to question, what do citizens on the African continent think about the direction in which their respective countries are moving? 
                      This project explores the direction in which African citizens believe their respective countries are going – bringing levels and paths of development back on the ground. 
                      By showing what factors influence the direction in which one thinks their country is going, this project begins to unpack local sentiment toward development, illuminating greater understanding and potential action. 
                      This project serves as foundational work for my senior thesis on Democracy and Development in developing nations."
                      ),
                   fluidPage(
                     fluidRow(column(6,
                                     h3("People are Less Optimistic"),
                                     p("As the graph on the left shows, between 2013 and 2018 the average of people on the African continent who believe their country is heading in the wrong direction has increased.
                                        If we compare the two graphs that offer a country breakdown per year of sentiment toward the direction of development of each country, there seems a general shift of pesimism.
                                        This shift of people toward believing that the country is going in the wrong direction is most notable in Niger, Namibia and Zambia.
                                        Interestingly, Kenya and Uganda do not follow this trend, with more than 10% increase from 2013 to 2018 people believing that the country is going in the right direction."
                                     ),
                                     ),
                              column(6, 
                                     selectInput("plotInput", label = "Choose one:",
                                                  choices = c("Year" = "year",
                                                    "2018" = "2018",
                                                    "2013" = "2013"),
                                                  selected = "Year"),
                                     plotOutput("direction")
                                     
                     )),
                   
                     fluidRow(column(6, 
                                     leafletOutput("map", height = 700),
                     ),
                              column(6, 
                                     h3("taking a closer look at Africa"),
                                     p("As we can see from the map on the right, the direction in which respondents believe their country is going is variable across the continent.
                                       However, no entire nation believes they are going in the right direction.
                                       The scale of backward to forward is 0 to 1 with lower numbers representing a higher percentage of the population who believe  the country is moving in the wrong direction.
                                       Click on the various countries in Africa to view additional information about the country"
                            ),
                     )))),
               
               ###### SECOND PAGE #########               
               
               tabPanel(align = "center", "Modelling Direction",
                         h2("Modelling Direction"),
                         p("The data collected for this project comes from the publicly available Afrobarometer study.
                            Afrobarometer is a comparative series of public attitude surveys that asses African citizen's attitudes to democracy, governance, development and everything inbetween since 1999."
                         ),
                        h3("Variables in model"),
                        p("write about variables"),
                        column(6, 
                               wellPanel(
                                 h3("2018 Regression model"),
                                 gt_output("tbl_2018"),
                                 br(),
                                 p("explain model")
                               )),
                        column(6,
                               wellPanel(
                                 h3("2013 Regression model"),
                                 gt_output("tbl_2013"),
                                 br(),
                                 p("explain model")
                               )),
                        br(),
                        sidebarLayout(
                          sidebarPanel(
                            h3("Run a Regression for each country:"),
                            
                            selectInput("reg_country", label = "Country:",
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
                            mainPanel(p("Hi"),
                             gt_output("regression_country")
                            )
                          )
                        
               ),

                         
                         
######## THIRD PAGE #########

tabPanel(align = "center", "About Page", 
         h2("Background Information"),
         p("Background info on topic"),
         p("Background info on project"),
         br(),
         p(a("link to my github repo!",  href ="https://github.com/Nikita-Lledo/final-project.git"
         )),
         br(),
         h3("Background on the Data"),
         p("list data"),
         br(), 
         h3("About Me"),
         p("", 
           a("nikitalledo@college.harvard.edu", href = "mailto:nikitalledo@college.harvard.edu"),
           "."
         )
)

))