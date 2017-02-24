library(shiny)
library(dplyr)
library(magrittr)
data0 <- read.csv("https://raw.githubusercontent.com/hirogami/Tabsets201609/master/data0")
#hallo
# Define server logic for random distribution application
shinyServer(function(input, output) {
  
  # Reactive expression to generate the requested distribution. This is 
  # called whenever the inputs change. The renderers defined 
  # below then all use the value computed from this expression
  data <- reactive({  
    dist <- switch(input$dist,
                   year1 = filter(data0,year==1),
                   year2 = filter(data0,year==2),
                   year3 = filter(data0,year==3),
                   yearall = data0,
                   year1)
    
    dist[,"marks"]

  })
  
  # Generate a plot of the data. Also uses the inputs to build the 
  # plot label. Note that the dependencies on both the inputs and
  # the 'data' reactive expression are both tracked, and all expressions 
  # are called in the sequence implied by the dependency graph
  output$plot <- renderPlot({
    dist <- input$dist

    hist(data(), 
         main=paste(dist))
  }) 
  
  # Generate a summary of the data
  output$summary <- renderPrint({
    summary.n <- summary(data())
    summary.n["n"] <- NROW(data())
    summary.n
      })
})
