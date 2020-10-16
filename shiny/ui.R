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
               "App Title",
               tabPanel(
                   "Page1", p("Here's some words"),
                   h1("here is a header")),
               # You would add your content within the parentheses above.
               tabPanel(
                   "Page2", 
                   plotOutput("cars_plot")
               )
    ))