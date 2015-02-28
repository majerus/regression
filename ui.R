# Define UI for application 
shinyUI(fluidPage(
  
# Application title
  
  titlePanel("Bivariate Regression"),

# Sidebar 

  sidebarLayout(
    sidebarPanel(      
      textInput("name", label = h5("Name"), value = "Name"),
      HTML('</br>'),
      selectInput("dataset", h5("Choose a dataset:"), choices = c("cars", "longley", "MLB","rock", "pressure")),        
      HTML('</br>'),
      uiOutput('dv'),    
      HTML('</br>'),
      uiOutput('iv'),
      HTML('</br>'),
      radioButtons('format', h5('Document format'), c('PDF', 'HTML', 'Word'), inline = TRUE),
      downloadButton('downloadReport'),
      includeHTML('help.html')),

# main panel 
    
    mainPanel(
      tabsetPanel(type = "tabs", 
                  tabPanel("Data",
                           HTML("</br>Select a data set from the 'Choose a dataset menu' or enter your own data below </br> </br>"),
                           numericInput("obs", label = h5("Number of observations to view"), 10),
                           tableOutput("view")),
                                                             
                  tabPanel("Summary Statistics",
                           verbatimTextOutput("summary"),
                           textInput("text_summary", label = "Interpretation", value = "Enter text...")),
                
                  tabPanel("Histograms",                   
                            plotOutput("distPlot_dv"),
                            sliderInput("bins_dv", "Number of bins:", min = 1, max = 50, value = 7),  
                            textInput("text_hist_dv", label = "Interpretation", value = "Enter text..."),
                           
                            plotOutput("distPlot_iv"),
                            sliderInput("bins_iv", "Number of bins:", min = 1, max = 50, value = 7),
                            textInput("text_hist_iv", label = "Interpretation", value = "Enter text...")),                       
                           
                  tabPanel("Scatter Plot",                   
                           plotOutput("scatter"),
                           textInput("text_scatter", label = "Interpretation", value = "Enter text...")),  
                  
                  tabPanel("Correlations",                   
                           htmlOutput("corr"),
                           HTML('</br> </br>'),
                           textInput("text_correlation", label = "Interpretation", value = "Enter text...")),
                  
                  tabPanel("Model",                   
                           verbatimTextOutput("model"),
                           textInput("text_model", label = "Interpretation", value = "Enter text...")),
                  
                  tabPanel("Residuals",                   
                           plotOutput("residuals_hist"),
                           plotOutput("residuals_scatter"),
                           plotOutput("residuals_qqline"),
                           textInput("text_residuals", label = "Interpretation", value = "Enter text..."))
                 )                         
          ))
))