library(shiny)

shinyUI(fluidPage(
  includeCSS("www/sideStyle.css"),
  
  # Sidebar with counts and button for switching between count types
  sidebarLayout(
    absolutePanel(
      sidebarPanel(
        textOutput("achenes"), br(),
        
        actionButton("zoomin", "+"),
        actionButton("zoomout", "-"),
        textOutput("zoomAmt")
      ), draggable = T
    ),
    
    # Plots with x-ray image and points
    mainPanel(
      absolutePanel(
        htmlOutput("imgPlot"),
        top = "40px"
      ),
      absolutePanel(
        plotOutput("pointPlot", width = "3000px", height = "4000px",
                   click = "achene", dblclick = "removeAch"),
        top = "40px"
      ),
      # this is only here because we can't get the image without it
      textOutput("queryText")
    )
  )
))
