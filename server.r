shinyServer(function(input, output) {
  
# list of data sets
  datasetInput <- reactive({
    switch(input$dataset,
           "cars" = mtcars,
           "longley" = longley,
           "MLB" = mlb11,    
           "rock" = rock,
           "pressure" = pressure, 
           "Your Data" = df())
  })
  
# dependent variable
  output$dv = renderUI({
    selectInput('dv', h5('Dependent Variable'), choices = names(datasetInput()))
  })
  
# independent variable
  output$iv = renderUI({
    selectInput('iv', h5('Independent Variable'), choices = names(datasetInput()))
  })
  
# regression formula
  regFormula <- reactive({
    as.formula(paste(input$dv, '~', input$iv))
  })
  
# bivariate model
  model <- reactive({
     lm(regFormula(), data = datasetInput())
  })
  
  
# create graphics 

# data view 
  output$view <- renderTable({
    head(datasetInput(), n = input$obs)
  })
  
# summary statistics
  output$summary <- renderPrint({
      summary(cbind(datasetInput()[input$dv], datasetInput()[input$iv]))
  })
  
# histograms   
  output$distPlot_dv <- renderPlot({
    x    <- datasetInput()[,input$dv]  
    bins <- seq(min(x), max(x), length.out = input$bins_dv + 1)
    hist(x, breaks = bins, col = 'darkgray', border = 'white', main = 'Dependent Variable', xlab = input$dv)
  })

  
  output$distPlot_iv <- renderPlot({
    x    <- datasetInput()[,input$iv]  
    bins <- seq(min(x), max(x), length.out = input$bins_iv + 1)
    hist(x, breaks = bins, col = 'darkgray', border = 'white', main = 'Independent Variable', xlab = input$iv)
  })
  
# scatter plot 
  output$scatter <- renderPlot({
     plot(datasetInput()[,input$iv], datasetInput()[,input$dv],
       xlab = input$iv, ylab = input$dv,  main = "Scatter Plot of Independent and Dependent Variables", pch = 16, 
       col = "black", cex = 1) 
  
     abline(lm(datasetInput()[,input$dv]~datasetInput()[,input$iv]), col="grey", lwd = 2) 
  })

# correlation matrix
  output$corr <- renderGvis({
    d <- datasetInput()[,sapply(datasetInput(),is.integer)|sapply(datasetInput(),is.numeric)] 
    cor <- as.data.frame(round(cor(d), 2))
    cor <- cbind(Variables = rownames(cor), cor)
    gvisTable(cor) 
  })

# bivariate model
  output$model <- renderPrint({
    summary(model())
  })

# residuals
  output$residuals_hist <- renderPlot({
    hist(model()$residuals, main = paste(input$dv, '~', input$iv), xlab = 'Residuals') 
  })

  output$residuals_scatter <- renderPlot({
    plot(model()$residuals ~ datasetInput()[,input$iv], xlab = input$iv, ylab = 'Residuals')
    abline(h = 0, lty = 3) 
  })

  output$residuals_qqline <- renderPlot({
    qqnorm(model()$residuals)
    qqline(model()$residuals) 
  })


df <- reactive({
  hot.to.df(input$hotable1) # this will convert your input into a data.frame
  })


# download report
  output$downloadReport <- downloadHandler(
    filename = function() {
    paste('my-report', sep = '.', switch(
    input$format, PDF = 'pdf', HTML = 'html', Word = 'docx'
    ))
  },
  
  content = function(file) {
    src <- normalizePath('report.Rmd')
    owd <- setwd(tempdir())
    on.exit(setwd(owd))
    file.copy(src, 'report.Rmd')
    
    library(rmarkdown)
    out <- render('report.Rmd', switch(
      input$format,
      PDF = pdf_document(), HTML = html_document(), Word = word_document()
    ))
    file.rename(out, file)
  })

})
