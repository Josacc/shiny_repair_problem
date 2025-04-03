library(shiny)
library(plotly)
library(tidyverse)
library(DT)


function(input, output, session) {

  observeEvent(input$info_button_markov_process, {
    show_alert(
      session = session,
      title   = "",
      text    = tags$div(
        tags$h3("Information",
                style = "color: #0076C8; font-weight: bold; text-align: center"),
        tags$br(), tags$br(),
        style = "text-align: justify;
        margin-left:  auto;
        margin-right: auto;",
        tags$b('A repair problem', style = "font-weight: bold"),
        tags$br(), tags$br(),
        'A system needs n working machines to be operational. To guard against
          machine breakdown, additional machines are kept available as spares.
          Whenever a machine breaks down it is immediately replaced by a spare
          and is itself sent to the repair facility, which consists of a single
          repairperson who repairs failed machines one at a time. Once a failed
          machine has been repaired it becomes available as a spare to be used
          when the need arises.',
        tags$br(),
        'The system is said to “crash” when a machine fails and no spares are
          available.',
        tags$b(
          'We are interested in simulating the time at which the system crashes.',
          style = "font-weight: bold"
        )
      ),
      html  = TRUE,
      width = "55%"
    )
  })

  computing <- eventReactive(input$go, {
    Sys.sleep(1)
    round(g(input$n, input$s, (input$l)/1000, 100), 3)
  })

  output$mean_vida  <- renderPrint({
    cat(str_c("Average lifetime (in days) of the system before collapse:\n",
              computing()))
  })
}
