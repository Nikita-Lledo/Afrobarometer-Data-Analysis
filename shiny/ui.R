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
# Define UI for application that draws a histogram
shinyUI(
    navbarPage(theme = shinytheme("journal"), 
               "Afrobarometer",
               tabPanel(
                   "About", 
                   h1("Afrobarometer Data Analysis"),
                   p("This data project will be taking data from 7 surveys run by the Afrobarometer. 
                   Afrobarometer is a comparative series of public attitude surveys that assess African citizen's attitudes to democracy and governance, markets and civil society.
                   This data analytics project is going to specifcially focus on only a portion of the questions that are asked and focusing speficially on governance. 
                   We are going to explore both differentials between countries within a survey period as well as differences over time. 
                   The Afrobarometer survey has been running since 1999 and has expanded from covering 7 countries to 34 countries in the lastest survey.
                   This is the beginning of a great project. The data between years still needs to be merged. The questions not only differ between countries but between years. 
                   Over the next week years extensive data wrangling and visualization will take place in order to better understand the data as well as draw new conclusions that could point to solutions."),
                   p(a("link to my github repo!",  href ="https://github.com/Nikita-Lledo/final-project.git")),
               ),
               tabPanel(
                   "Data", 
                   p("This will show the number of respondents per country that participated in the 2018 survey"),
                   plotOutput("location")
                   
               )
    ))