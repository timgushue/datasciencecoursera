library(shiny)

shinyUI(fluidPage(
  sidebarLayout(
    sidebarPanel(
      h1("Instructions"),
      helpText("Generate a new data set, then adjust the z-score slider to change the
               anomaly threshold."),
      helpText("If the z-score for an event is greater than the value
               set below, it will be highlighted on the chart by a yellow bar. "),
      br(),
      actionButton("generateButton", "Regenerate Data"),
      br(),
      br(),
      br(),
      sliderInput("zScore",
                  "Z-Score for Outliers",
                  min = 0,
                  max = 5,
                  value = 3,
                  step  = 0.1),
      br(),
      br()
    ),
    
    mainPanel(
      withMathJax(), 
      
      h1("Statistical Anomaly Detection"),
      p(" The following discription was taken from Trevor Whitney's", a("Anomaly Detection",
          href = "http://trevorwhitney.com/data_mining/anomaly_detection"), "blog."),

      strong(em(p("\"The statistical approach to anomaly detection works well on data with a Guassian 
        distribution. They are primarily focused on discovering how far data points fall 
        from the mean of the data, and uses an outlier score of how many standard deviations 
        away from the mean that a point is in a data set."),

      p("About 68% of all the data points are within one standard deviation 
        from the mean. About 95% of the data points are withing two standard deviations from 
        the mean. Finally, over 99% of the data is within three standard deviations from the 
        mean."),

      p("Statistically based anomaly detection uses this knowledge to discover outliers. 
        A dataset can be standardized by taking the z-score of each point. A z-score is a 
        measure of how many standard deviations a data point is away from the mean of the data. 
        Any data-point that has a z-score higher than 3 is an outlier, and likely to be an 
        anomaly. As the z-score increases above 3, points become more obviously anomalous. A 
        z-score is calculated using the following equation.\""))),
      helpText("$$z = \\frac{x - \\mu}\\sigma$$"),

      plotOutput("outputPlot")
    )
  )
))