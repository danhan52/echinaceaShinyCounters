library(shiny)
library(jpeg)

# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
  locations <- reactiveValues(
    achs = data.frame(x = numeric(0), y = numeric(0), type = character(0),
                      stringsAsFactors = F)
  )
  
  cur <- reactiveValues(
    counting = "full"
  )
  
  xImage <- reactiveValues(
    imgLoc = NULL
  )
  
  observeEvent(input$removeAch, {
    if (nrow(locations$achs) > 0) {
      near <- nearPoints(locations$achs, input$removeAch, "x", "y",
                           maxpoints = 1, allRows = T, threshold = 8)
      locations$achs <- locations$achs[!near$selected_,]
    }
  })
  
  observeEvent(input$achene, {
    len <- nrow(locations$achs) + 1
    locations$achs[len, "x"] <- input$achene$x
    locations$achs[len, "y"] <- input$achene$y
    locations$achs[len, "type"] <- cur$counting
  })
  
  observeEvent(input$switchCt, {
    if (cur$counting == "full") {
      cur$counting <- "partial"
    } else if (cur$counting == "partial") {
      cur$counting <- "empty"
    } else if (cur$counting == "empty") {
      cur$counting <- "full"
    }
  })
  
  observeEvent(input$key, {
    if (input$key[1] == 83) {
      if (cur$counting == "full") {
        cur$counting <- "partial"
      } else if (cur$counting == "partial") {
        cur$counting <- "empty"
      } else if (cur$counting == "empty") {
        cur$counting <- "full"
      }
    }
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
                  '" style="width:700px;height:1000px;">'))
    }
  })
  
  # create plot with points
  output$pointPlot <- renderPlot({
    par(mar = c(0,0,0,0))
    plot(1, 1, xlim=c(1,2), ylim=c(1,2), asp=1, type='n', xaxs='i', yaxs='i',
         axes = F, xlab='', ylab='', bty='n', bg = NA)
    
    points(y ~ x, locations$achs, subset = locations$achs$type == "full",
           pch = 21, bg = "green", cex = 1.5)
    points(y ~ x, locations$achs, subset = locations$achs$type == "partial",
           pch = 21, bg = "royalblue", cex = 1.5)
    points(y ~ x, locations$achs, subset = locations$achs$type == "empty",
           pch = 21, bg = "red", cex = 1.5)
  }, bg = "transparent")
  
  
  output$nowCt <- renderUI({
    if (cur$counting == "full") {
      HTML(paste0("<div>Now counting: <span class=full>FULL</span>"))
    } else if (cur$counting == "partial") {
      HTML(paste0("<div>Now counting: <span class=partial>PARTIAL</span>"))
    } else if (cur$counting == "empty") {
      HTML(paste0("<div>Now counting: <span class=empty>EMPTY</span>"))
    }
  })
  output$full <- renderUI({
    HTML(paste0("<div><span class=full>full</span> achenes: ",
                sum(locations$achs$type == "full"), "</div>"))
  })
  output$partial <- renderUI({
    HTML(paste0("<div><span class=partial>partial</span> achenes: ",
                sum(locations$achs$type == "partial"), "</div>"))
  })
  output$empty <- renderUI({
    HTML(paste0("<div><span class=empty>empty</span> achenes: ",
               sum(locations$achs$type == "empty"), "</div>"))
  })
  
})
