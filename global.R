
library(shinyapps)
library(googleVis)
library(knitr)
library(shiny)
library(shinysky)

download.file("http://www.openintro.org/stat/data/mlb11.RData", destfile = "mlb11.RData")
load("mlb11.RData")

rownames(mlb11) <- mlb11$team
mlb11$team <- NULL

