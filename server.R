library(shiny)
library(plotly)
library(tidyverse)
library(DT)


function(input, output, session) {
  # Simular un problema de reparación de máquinas y
  # determinar el tiempo de colapso promedio del sistema.

  # n: número de máquinas en funcionamiento.
  # s: número de máquinas de repuesto.
  # l: parámetro de la distribución exponencial que genera
  # el tiempo de reparación de una máquina.

  # Función que genera valores de una V.A. exp(l)
  e <- function(l){
    x <- (-1/l) * log(runif(1))
    return(x)
  }

  # Función principal
  f <- function(n, s, l){
    t <- 0
    r <- 0
    t_reparacion <- Inf
    X <- runif(n)
    t_I <-  sort(X)  #ordena de menor a mayor los elementos del vector x

    while (r < s + 1) {
      if(t_I[1] < t_reparacion){
        t <- t_I[1]
        r <- r + 1       # Debido al fallo de una máquina
        if(r < s + 1){
          x <- runif(1)
          t_I[1] <- t + x
          t_I <- sort(t_I)
        }
        if(r == 1){
          Y <- e(l)
          t_reparacion <- t + Y
        }
      }else{
        t <- t_reparacion
        r <- r - 1
        if(r > 0){
          Y <- e(l) #Tiempo de reparación
          t_reparacion <- t + Y # Instante en que vuelve al conjunto de las máquinas de repuesto
        }else{t_reparacion <- Inf}
      }
    }
    T_colapso <- t
    return(T_colapso)
  }

  # Función para obtener el valor esperado del tiempo de colapso del sistema.
  g <- function(n, s, l, M){
    a <- vector()
    for (k in 1:M) {
      a[k] <- f(n, s, l)
    }
    return(mean(a))
  }

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
