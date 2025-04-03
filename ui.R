# "Markov process"

library(shiny)
library(plotly)
library(tidyverse)
library(DT)
library(shinyWidgets)
library(shinycssloaders)

fluidPage(
  titlePanel("Markov process"),
  fluidRow(
    column(
      width = 3,
      h4(
        p(strong("A repair problem")),
        style = "color: #3c8dbc"
      )
    ),
    column(
      width = 1,
      actionBttn(
        inputId = "info_button_markov_process",
        label   = "",
        icon    = icon("info-circle"),
        style   = "jelly"
      )
    )
  ),
  br(),
  sidebarLayout(
    sidebarPanel(
      width = 7,
      sliderInput(
        inputId = "n",
        label   = "Amount operating machines:",
        min     = 0,
        max     = 500,
        step    = 5,
        value   = 10
      ) ,
      sliderInput(
        inputId = "s",
        label   = "Amount of spare machines:",
        min     = 0,
        max     = 500,
        step    = 5,
        value   = 5
      ) ,
      sliderInput(
        inputId = "l",
        label   = "Average time (in hours) to repair one machine:",
        min     = 1,
        max     = 10,
        step    = 1,
        value   = 5
      )
    ),
    mainPanel(
      width = 5,
      actionButton("go", "Go"),
      br(), br(),
      withSpinner(verbatimTextOutput(outputId = "mean_vida"))
    )
  )
)
