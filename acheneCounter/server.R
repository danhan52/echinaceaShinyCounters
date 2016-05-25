library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
  locations <- reactiveValues(
    achs = data.frame(x = numeric(0), y = numeric(0))
  )
  
  
  xImage <- reactiveValues(
    imgLoc = NULL
  )
  
  zoom <- reactiveValues(
    mult = 1
  )
  
  observeEvent(input$removeAch, {
    if (nrow(locations$achs) > 0) {
      tempLocs <- locations$achs
      tempLocs$y <- tempLocs$y * zoom$mult
      tempLocs$x <- tempLocs$x * zoom$mult
      
      near <- nearPoints(tempLocs, input$removeAch, "x", "y",
                           maxpoints = 1, allRows = T, threshold = 8)
      locations$achs <- locations$achs[!near$selected_,]
    }
  })
  
  observeEvent(input$zoomin, {
    zoom$mult <- 4/3 * zoom$mult
  })
  
  observeEvent(input$zoomout, {
    zoom$mult <- 3/4 * zoom$mult
  })
  
  observeEvent(input$achene, {
    len <- nrow(locations$achs) + 1
    locations$achs[len, "x"] <- input$achene$x / zoom$mult
    locations$achs[len, "y"] <- input$achene$y / zoom$mult
  })
  
  # Parse the GET query string
  output$queryText <- renderText({
    xImage$imgLoc <- parseQueryString(session$clientData$url_search)$img
    
    ""
  })
  
  # create plot of image
  output$imgPlot <- renderUI({
    if (!is.null(xImage$imgLoc)) {
      HTML(paste0('<img src="', xImage$imgLoc,
                  '" style="width:', 2250*zoom$mult, 'px;height:', 3000*zoom$mult, 'px;">'))
    }
  })
  
  # create plot with points
  output$pointPlot <- renderPlot({
    par(mar = c(0,0,0,0))
    if (!is.null(xImage$imgLoc)) {
      plot(1, 1, xlim=c(0, 1), ylim=c(-1, 0),
           type='n', xaxs='i', yaxs='i', axes = F, xlab='', ylab='', bty='n',
           bg = NA)
    } else {
      plot(1, 1, xlim=c(0, 1), ylim=c(-1, 0), type='n', xaxs='i', yaxs='i',
           axes = F, xlab='', ylab='', bty='n', bg = NA)
    }
    
    tempLocs <- locations$achs
    tempLocs$y <- tempLocs$y * zoom$mult
    tempLocs$x <- tempLocs$x * zoom$mult
    
    points(y ~ x, tempLocs, pch = 21, bg = "red", cex = 1.5*(zoom$mult)^(1/2.5))
  }, bg = "transparent")
  
  
  output$achenes <- renderText({
    paste("Achenes counted:", nrow(locations$achs))
  })
  
  output$zoomAmt <- renderText({
    paste0("Zoom: ", round(zoom$mult*100), "%")
  })
  
})
