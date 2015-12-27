# server.R

library(ggplot2)

shinyServer(function(input, output) {
  
  data <- reactive({
    # Generate a random chi-squared distribution with 100 points 
    # and 10 degrees of freedom.
    foo <- input$generateButton  
    rchisq(100, df = 5)
  })
  
  output$outputPlot <- renderPlot({
    # Calculate statistics for the data distribution
  	chisq <- data()
    m <- mean(chisq)
    stdev <- sd(chisq)

    # Calculate the z-score for each data point and return the value
    # for those above the slider threshold.
  	zScore <- input$zScore
    distance <- sapply(chisq, function(x) { abs(x-m)} )
    outliers <- sapply(distance, function(x) { 
    	if (x >= zScore*stdev) x + m
    	else 0
    })

    df <- data.frame(Index = c(1:length(chisq)), Events = chisq, Outliers = outliers)

    ggplot(
      df,
      aes(Index, Events, Outliers)) + 
  	geom_bar(
      aes(Index, Outliers),
      stat="identity",
      colour = "yellow",
      fill = "yellow",
      alpha = 0.5) +
  	geom_point(
      aes(Index, Events),
      colour = "orangered1",
      size = 3) +
  	labs(
      title = "Randomly Generated Events",
      x = "Event Value",
      y = "Event Index")

  })
})