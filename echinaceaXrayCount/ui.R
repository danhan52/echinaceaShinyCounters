library(shiny)

shinyUI(fluidPage(
  includeCSS("www/sideStyle.css"),
  
  # This is where we create the top section of the page including the logo
  # and the banner image. See the sideStyle.css for details of styling
  div(class = "cbgLogo",
      a(href = "http://echinaceaproject.org/lab",
        img(src = "http://echinaceaproject.org/lab/sites/all/themes/cbg_custom/logo.png",
            alt = "echinaceaproject.org")), align = "center", class = "cbglogo"),
  div(class = "echProj",
      h1(class = "site-name",
         a(href = "http://echinaceaproject.org/lab", "echinaceaproject.org",
           class = "the-actual-site")),
      align = "center"),
  div(class = "greenbar"),
  div(class = "bannerImage",
      img(src = "http://echinaceaproject.org/lab/sites/default/files/measuringPlantsAtHegg_2815.png")
  ),
  
  # a script that allows for keyboard presses to add input to shiny
  tags$script('$(document).on("keydown", function (e) {
                Shiny.onInputChange("key", [e.which, e.timeStamp]);
              });'),
  
  # Sidebar with counts and button for switching between count types
  sidebarLayout(
    absolutePanel(
      sidebarPanel(
        htmlOutput("nowCt"), # what is being counting
        br(),
        htmlOutput("full"), # number of full achenes
        htmlOutput("partial"), # number of partial achenes
        htmlOutput("empty"), # number of empty achenes
        br(),
        
        actionButton("switchCt", "Switch counting type"),
        HTML("<div>or press the 's' key to switch</div>")
      ), draggable = T
    ),
    
    # Plots with x-ray image and points
    mainPanel(
      absolutePanel(
        htmlOutput("imgPlot"),
        top = "40px", bottom = "40px", left = "320px"
      ),
      absolutePanel(
        plotOutput("pointPlot", width = "700px", height = "1000px",
                   click = "achene", dblclick = "removeAch"),
        top = "40px", bottom = "40px", left = "320px"
      ),
      # this is only here because we can't get the image without it
      textOutput("queryText")
    )
  )
))
