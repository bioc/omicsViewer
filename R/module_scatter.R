#' @description Utility plotly scatter
#' @description Function should only be used for the developers
#' @param x x values
#' @param y y values, same legnth as x
#' @param xlab label x-axis
#' @param ylab label y-axis
#' @param color color vector, same length as x and y
#' @param shape shape vector, same length as x and y
#' @param size size vector, same length as x and y
#' @param tooltips tooltip vector, same length as x and y
#' @param regressionLine show or not show regressionLine
#' @param source plotly source of plot
#' @param sizeRange size range of points 
#' @param highlight whic value to highlight
#' @param highlightName legend for highlighted values
#' @param vline vertical line, not implemented 
#' @param hline horizontal line, not implmented
#' @param rect rectangle coordinate in the form c(x0, x1, y0, y1)
#' @param drawButtonId not used currently
#' @param inSelection the index which points is in selection, will be shown in higher opacity.
#' @examples 
#' #' # scatter plot
#' # x <- rnorm(30)
#' # y <- x + rnorm(30, sd = 0.5)
#' # plotly_scatter(x , y)
#' # plotly_scatter(x, y, tooltips = paste("A", 1:30))
#' # plotly_scatter(x, y, tooltips = paste("A", 1:30), regressionLine = TRUE, rect = c(x0 = -1, x1 = 1, y0 = -1, y1 = 1), vline = 1, hline = -1)
#' # plotly_scatter(x, y, tooltips = paste("A", 1:30), regressionLine = TRUE, color = rep(c("a", "b"), #' time = c(10, 20)))
#' # plotly_scatter(x, y, tooltips = paste("A", 1:30), regressionLine = TRUE,
#                color = rep(c("a", "b"), time = c(10, 20)), shape = rep(c("A", "B"), time = c(20, #' 10)))
# plotly_scatter(x, y, tooltips = paste("A", 1:30), regressionLine = TRUE, size = sample(1:3, #' replace = TRUE, size = 30),
#                color = rep(c("a", "b"), time = c(10, 20)), shape = rep(c("A", "B"), time = c(20, #' 10))
#' #                )
#' # 
#' # ### beeswarm horizontal
#' # x <- rnorm(30)
#' # y <- sample(c("x", "y", "z"), size = 30, replace = TRUE)
#' # plotly_scatter(x = x , y = y)
#' # plotly_scatter(x, y, tooltips = paste("A", 1:30))
#' # plotly_scatter(x, y, tooltips = paste("A", 1:30), regressionLine = TRUE)
# plotly_scatter(x, y, tooltips = paste("A", 1:30), regressionLine = TRUE, color = rep(c("a", "b"), #' time = c(10, 20)))
#' # plotly_scatter(x, y, tooltips = paste("A", 1:30), regressionLine = TRUE, 
#                color = rep(c("a", "b"), time = c(10, 20)), shape = rep(c("A", "B"), time = c(20, #' 10)))
# plotly_scatter(x, y, tooltips = paste("A", 1:30), regressionLine = TRUE, size = sample(1:3, #' replace = TRUE, size = 30),
#                color = rep(c("a", "b"), time = c(10, 20)), shape = rep(c("A", "B"), time = c(20, #' 10)))
#' # 
#' 
#' ### beeswarm vertical
# x <- sample(c("x", "y", "z"), size = 30, replace = TRUE)
# y <- rnorm(30)
# plotly_scatter(x , y)
# plotly_scatter(x, y, tooltips = paste("A", 1:30))
# plotly_scatter(x, y, tooltips = paste("A", 1:30), regressionLine = TRUE, highlight = c(5, 8, 10))
# plotly_scatter(x, y, tooltips = paste("A", 1:30), regressionLine = TRUE, 10)
# dat <- readRDS("../../Dat/exampleEset.RDS")
# library(beeswarm)
# library(plotly)
# pd <- pData(dat)
# dt <- plotly_scatter(
#   x = pd$`General|All|MDR`,
#   y = pd$`General|All|Doubleing Time`,
#   color = pd$`General|All|Origin`,
#   highlight = c(5, 8, 10), 
#   rect = list(c(x0 = 50, x1 = 500, y0 = 30, y1 = 100)))
# dt <- plotly_scatter(
#   x = pd$`General|All|MDR`,
#   y = pd$`General|All|Doubleing Time`,
#   color = pd$`General|All|Origin`,
#   highlight = c(5, 8, 10),
#   rect = list(c(x0 = 50, x1 = 500, y0 = 30, y1 = 100), c(x0=-120, x1 = -30, y0 = 30, y1 = 100)))
# 
# dt <- plotly_scatter(
#   x = pd$`General|All|MDR`,
#   y = pd$`General|All|Doubleing Time`,
#   color = pd$`General|All|Origin`,
#   highlight = c(5, 8, 10), 
#   rect = list(c(x0 = 50, x1 = 500, y0 = 30, y1 = 100)))
# 
# 
# dt
#' # 
#' # dt <- plotly_scatter(x = pd$`General|All|Origin`,
#' #                      y = pd$`General|All|Doubleing Time`,
#' #                      color = pd$`General|All|Origin`)
#' # 
#' # dt <- plotly_scatter(y = pd$`General|All|Origin`,
#' #                      x = pd$`General|All|Doubleing Time`,
#' #                      color = pd$`General|All|Origin`, highlight = c(5, 8, 10))
#' # dt
#' # # dt$fig
#' @importFrom fastmatch fmatch
#' @importFrom beeswarm beeswarm
#' @import plotly
# function def

plotly_scatter <- function(
  x, y, xlab = "", ylab = "ylab", color = "", shape = "", size = 10, tooltips=NULL, # shape = "circle", color = "defaultColor",
  regressionLine = FALSE, source = "scatterplotlysource", sizeRange = c(5, 15), 
  highlight = NULL, highlightName = "Highlighted", inSelection = NA,
  vline = NULL, hline = NULL, rect = NULL, drawButtonId = NULL
) {
  options(stringsAsFactors = FALSE)
  
  i1 <- (is.factor(x) || is.character(x) || is.logical(x)) && is.numeric(y) # beeswarm vertical
  i2 <- (is.factor(y) || is.character(y) || is.logical(y)) && is.numeric(x) # beeswarm horizontal
  i3 <- is.numeric(y) && is.numeric(x) # scatter
  
  cutnumorchar <- function(x, n = 60, alt = "") {
    if (is.character(x) || is.factor(x)) {
      message ("too many distinct values, not suitable for color mapping!")
      v <- alt
    } else if (is.numeric(x)) {
      v <- as.character(cut(x, breaks = n, include.lowest = TRUE, dig.lab = 3))
    } else
      stop("cutnumorchar: x needs to be one of objects: numeric, character, factor")
    v
  }
  
  if (length(unique(color)) > 60) color <- cutnumorchar(color, alt = "") # alt = "defaultColor"
  if (length(unique(shape)) > 60) shape <- cutnumorchar(shape, alt = "") # alt = "circle"
  
  ## prepare data.frame differently
  if (i1) {
    names(y) <- paste0("Y", seq_along(y))
    df <- beeswarm(y ~ x, corral = "wrap", do.plot = FALSE, corralWidth = 0.75)
    df$index <- fmatch(rownames(df), paste(x, names(y), sep = "."))
    tlp <- sprintf("<b>%s: </b>%s<br><b>%s: </b>%s", xlab, df$x.orig, ylab, signif(df$y, digits = 3))

    ixlab <- table(df$x.orig)
    ixlab <- structure(paste0(names(ixlab), " (n=", ixlab, ")"), names = names(ixlab))
    df$x.orig <- ixlab[df$x.orig]

  } else if (i2) {
    names(x) <- paste0("X", seq_along(x))
    df0 <- beeswarm(x ~ y, corral = "wrap", do.plot = FALSE, corralWidth = 0.9)
    df <- df0
    df$x <- df0$y
    df$y <- df0$x
    df$index <- fmatch(rownames(df), paste(y, names(x), sep = "."))
    tlp <- sprintf("<b>%s: </b>%s<br><b>%s: </b>%s", xlab, signif(df$x, digits = 3), ylab, df$y.orig)
  } else if (i3) {
    df <- data.frame(x = x, y = y)
    df$index <- seq_len(nrow(df))
    tlp <- sprintf("<b>%s: </b>%s<br><b>%s: </b>%s", xlab, signif(x, digits = 3), ylab, signif(y, digits = 3))
  } else {    
    message('plotly_scatter: Unknown type x and/or y!')
    return(NULL)
  }
  
  f0 <- function(x, i) {
    if (length(x) == 1)
      x <- rep(x, max(i, na.rm = TRUE))
    # x[is.na(x)] <- "_NA_"
    x[i]
  } 

  df$color <- f0(color, i = df$index)
  df$shape <- f0(shape, i = df$index)
  df$size <- f0(size, i = df$index)
  
  if (!is.null(tooltips))
    tlp <- paste0("<b>", tooltips[df$index], "</b><br>", tlp)
  df$tlp <- tlp
  
  df$shape[is.na(df$shape)] <- "_NA_"
  df$color[is.na(df$color)] <- "_NA_"
  df$size[is.na(df$size)] <- min(df$size, na.rm = TRUE)
  if (!is.null(highlight)) {
    df$highlight <- FALSE
    df$highlight[which(df$index %in% highlight)] <- TRUE
  }
  
  df <- df[!(is.na(df$x) | is.na(df$y)), ]
  df <- df[order(df$x, decreasing = FALSE), ] ## DF reordered, should be carefully with returned values
  df$xyid <- paste(df$x, df$y)
  if (nrow(df) == 0)
    return(NULL)
  cc <- nColors(k = length(unique(df$color)))
  
  ############ plot #################
  mop <- NA
  if (!is.na(inSelection)) {
    mop <- rep(0.2, nrow(df))
    mop[inSelection] <- 0.75
  }

  fig <- plot_ly(data = df, source = source)
  if (i1 || i2) {
    # set.seed(8610)
    fig <- add_trace(fig, x = ~ x, y = ~ y, color = ~ color, colors = cc, symbol = ~ shape, size = ~ size, 
                     sizes = sizeRange, marker = list(sizemode = 'diameter', opacity = mop), type = "scatter", mode = "markers",
                     text = ~ tlp, hoverinfo = 'text', showlegend = FALSE)
    if (i1)
      fig <- plotly::layout(
        fig, yaxis = list(title = ylab), xaxis = list( title = xlab, tickvals = unique(round(df$x)), ticktext = unique(df$x.orig) )
      )
    if (i2)
      fig <- plotly::layout(
        fig, xaxis = list(title = xlab), yaxis = list( title = ylab, tickvals = unique(round(df$y)), ticktext = unique(df$x.orig) )
      )
  } else {
    # set.seed(8610)
    fig <- add_trace(
      fig, x = ~ x, y = ~ y, color = ~ color, colors = cc, symbol = ~ shape, size = ~ size, sizes = sizeRange,
      marker = list(sizemode = 'diameter', opacity = mop), text = ~ tlp, hoverinfo = "text", type = "scatter", mode = "markers"
    )
    # marker = list(size = ~ size, sizes = c(10, 50), sizemode = 'diameter') # this not warnings but doesn't work well
    if (regressionLine) {
      
      mod <- lm(df$y ~ df$x)
      prd <- predict(mod, newdata = data.frame(x), interval = 'confidence')
      df <- cbind(df, prd)
      # set.seed(8610)
      fig <- add_trace(
        fig, data = df, type = "scatter", mode = "lines", x = ~ x, y = ~ fit, line = list(color = "rgb(150, 150, 150)", width = 1), 
        hoverinfo='skip', showlegend = FALSE, name = "regression<br>line"
      )
      fig <- add_trace(
        fig, type = "scatter", mode = "lines", x = ~ x, y = ~ lwr, line = list(color = 'transparent', width = 1), 
        hoverinfo='skip', showlegend = FALSE
      )
      fig <- add_trace(
        fig, type = "scatter", mode = "lines", x = ~ x, y = ~ upr, line = list(color = 'transparent', width = 1),
        fill = 'tonexty', fillcolor='rgba(0,100,80,0.2)', hoverinfo='skip', showlegend = FALSE
      )
      t <- list(size = 12)
      ct <- cor.test(x, y)
      p <- signif(ct$p.value, digits = 2)
      r <- signif(ct$estimate, digits = 2)
      fig <- plotly::layout(fig, title = list(text = sprintf("R = %s; p-value = %s", r, p), font = t))
    }
  }
  if (!is.null(highlight)) {
    fig <- add_trace(
      fig, x = df$x[df$highlight], y = df$y[df$highlight], type = "scatter", mode = "markers", name = highlightName, 
      marker = list(size = 20, symbol = "circle-open", color = "black", line = list(width = 3)),  hoverinfo = "none",
      showlegend = FALSE
    )
  }
  
  if (is.list(rect) ) {
    rect <- lapply(rect, function(r1) {
      if ( any( !c("x0", "y0", "x1", "y1") %in% names(r1) ))
        return(NULL)
      list(type = "rect",
           fillcolor = "blue", line = list(color = "blue"), opacity = 0.1,
           x0 = r1["x0"], x1 = r1["x1"], xref = "x",
           y0 = r1["y0"], y1 = r1["y1"], yref = "y")
    })
  }
  fig <- plotly::layout(
    fig, xaxis = list(title = xlab), yaxis = list(title = ylab), shapes = rect,
    legend = list(orientation = 'h', xanchor = "left", x = 0, y = 1, yanchor='bottom'))
  
  if (is.null(drawButtonId))
    modeBarAdd <- NULL else
      modeBarAdd <- list( drawButton(drawButtonId) )
  
    fig <- plotly::config(
      fig,
      toImageButtonOptions = list(
        format = "svg",
        filename = "omicsViewerPlot",
        width = 700,
        height = 700
      ),
      modeBarButtonsToAdd = modeBarAdd
    )
  
  return(list(fig = toWebGL(fig), data = df))
  # return(list(fig = fig, data = df))
}


####
#' Shiny module for scatter plot using plotly - UI
#' @description Function should only be used for the developers
#' @param id id
#' @param height figure height
#' @return a tagList of UI components
#' @importFrom shinycssloaders withSpinner
#' @export
#' @examples
#' if (interactive()) {
#'   library(shiny)
#'   
#'   # two random variables
#'   x <- rnorm(30)
#'   y <- x + rnorm(30, sd = 0.5)
#'   
#'   # variables mapped to color, shape and size
#'   cc <- sample(letters[1:4], replace = TRUE, size = 30) 
#'   shape <- sample(c("S1", "S2", "S3"), replace = TRUE, size = 30)
#'   sz <- sample(c(10, 20, 30, replace = TRUE, size = 30))
#'   
#'   ui <- fluidPage(
#'     plotly_scatter_ui("test_scatter")
#'   )
#'   
#'   server <- function(input, output, session) {
#'     v <- callModule(plotly_scatter_module, id = "test_scatter",
#'                     # reactive_checkpoint = reactive(FALSE),
#'                     reactive_param_plotly_scatter = reactive(list(
#'                       x = x, y = y,
#'                       color = cc,
#'                       shape = shape,
#'                       size = sz,
#'                       tooltips = paste("A", 1:30)
#'                     )))
#'     observe(print(v()))
#'   }
#'   shinyApp(ui, server)
#'   
#'   
#'   
#'   # example beeswarm horizontal
#'   x <- rnorm(30)
#'   y <- sample(c("x", "y", "z"), size = 30, replace = TRUE)
#'   shinyApp(ui, server)
#'   
#'   # example beeswarm vertical
#'   x <- sample(c("x", "y", "z"), size = 30, replace = TRUE)
#'   y <- rnorm(30)
#'   shinyApp(ui, server)
#'   
#'   # return values 
#'   x <- c(5, 6, 3, 4, 1, 2)
#'   y <- c(5, 6, 3, 4, 1, 2)
#'   ui <- fluidPage(
#'     plotly_scatter_ui("test_scatter")
#'   )
#'   server <- function(input, output, session) {
#'     v <- callModule(plotly_scatter_module, id = "test_scatter",
#'                     reactive_param_plotly_scatter = reactive(list(
#'                       x = x, y = y, tooltips = paste("A", 1:6), highlight = 2:4
#'                     )))
#'     
#'     observe(print(v()))
#'   }
#'   shinyApp(ui, server)
#' }
plotly_scatter_ui <- function(id, height = "400px") {
  ns <- NS(id)
  tagList(
    uiOutput(ns('htest')),
    uiOutput(ns("regTickBox")),
    shinycssloaders::withSpinner(
      plotlyOutput(ns("plotly.scatter.output"), height = height), type = 8, color = "green"
    )
  )
}

#' Shiny module for scatter plot using plotly - Module
#' @description Function should only be used for the developers
#' @param input input
#' @param output output
#' @param session sesion
#' @param reactive_param_plotly_scatter reactive parammeters for plotly_scatter
#' @param reactive_regLine logical show or hide the regression line
#' @param reactive_checkpoint checkpoint
#' @param htest_var1 when the plot is a beeswarmplot, two groups could be selected for two group comparison, this 
#'   argument gives the default value. Mainly used for restoring the saved session.
#' @param htest_var2 see above
#' @importFrom fastmatch '%fin%'
#' @return a list containing the information about the selected data points
#' @export
#' @examples
#' if (interactive()) {
#'   library(shiny)
#'   
#'   # two random variables
#'   x <- rnorm(30)
#'   y <- x + rnorm(30, sd = 0.5)
#'   
#'   # variables mapped to color, shape and size
#'   cc <- sample(letters[1:4], replace = TRUE, size = 30) 
#'   shape <- sample(c("S1", "S2", "S3"), replace = TRUE, size = 30)
#'   sz <- sample(c(10, 20, 30, replace = TRUE, size = 30))
#'   
#'   ui <- fluidPage(
#'     plotly_scatter_ui("test_scatter")
#'   )
#'   
#'   server <- function(input, output, session) {
#'     v <- callModule(plotly_scatter_module, id = "test_scatter",
#'                     # reactive_checkpoint = reactive(FALSE),
#'                     reactive_param_plotly_scatter = reactive(list(
#'                       x = x, y = y,
#'                       color = cc,
#'                       shape = shape,
#'                       size = sz,
#'                       tooltips = paste("A", 1:30)
#'                     )))
#'     observe(print(v()))
#'   }
#'   shinyApp(ui, server)
#'   
#'   
#'   
#'   # example beeswarm horizontal
#'   x <- rnorm(30)
#'   y <- sample(c("x", "y", "z"), size = 30, replace = TRUE)
#'   shinyApp(ui, server)
#'   
#'   # example beeswarm vertical
#'   x <- sample(c("x", "y", "z"), size = 30, replace = TRUE)
#'   y <- rnorm(30)
#'   shinyApp(ui, server)
#'   
#'   # return values 
#'   x <- c(5, 6, 3, 4, 1, 2)
#'   y <- c(5, 6, 3, 4, 1, 2)
#'   ui <- fluidPage(
#'     plotly_scatter_ui("test_scatter")
#'   )
#'   server <- function(input, output, session) {
#'     v <- callModule(plotly_scatter_module, id = "test_scatter",
#'                     reactive_param_plotly_scatter = reactive(list(
#'                       x = x, y = y, tooltips = paste("A", 1:6), highlight = 2:4
#'                     )))
#'     
#'     observe(print(v()))
#'   }
#'   shinyApp(ui, server)
#' }
#' @return an reactive object containing the information of selected, brushed points.

plotly_scatter_module <- function(
  input, output, session, reactive_param_plotly_scatter, reactive_regLine = reactive(FALSE),
  reactive_checkpoint = reactive(TRUE), htest_var1 = reactive(NULL), htest_var2 = reactive(NULL)
  ) {
  
  options(warn = -1)
  ns <- session$ns
  
  hm <- reactive({
    x <- reactive_param_plotly_scatter()$x
    y <- reactive_param_plotly_scatter()$y
    i1 <- (is.factor(x) || is.character(x)) && is.numeric(y) # beeswarm vertical
    i2 <- (is.factor(y) || is.character(y)) && is.numeric(x) # beeswarm horizontal
    i3 <- is.numeric(y) && is.numeric(x) # scatter
    list( scatter = i3, beeswarm = i1 || i2, beeswarm.vertical = i1)
  })
  
  ################## dynamic UI for significance test ###################
  choices <- reactive({
    req(reactive_checkpoint())
    req(hm()$beeswarm)
    x <- reactive_param_plotly_scatter()$x
    y <- reactive_param_plotly_scatter()$y
    if (hm()$beeswarm.vertical) {
      v <- x 
      num <- y
    } else {
      v <- y
      num <- x
    }    
    list(group = sort(unique(v)), x = num, f = v)
  })
  
  output$htest <- renderUI({
    fluidRow(
      column(3, uiOutput(ns("uiGroup1")) ),
      column(3, uiOutput(ns("uiGroup2")) ),
      column(6, DT::dataTableOutput(ns("testResult")) )
    )
  })


  htv1 <- reactiveVal()
  htv2 <- reactiveVal()
  observe({
    if (is.null(htest_var1()))
      htv1(choices()$group[1]) else
        htv1(htest_var1())

    if (is.null(htest_var2()))
      htv2(choices()$group[2]) else
        htv2(htest_var2())
    })  
  
  output$uiGroup1 <- renderUI({
    req(reactive_checkpoint())    
    selectInput(inputId = ns("group1"), "group 1", choices = choices()$group, selected = htv1(), selectize = TRUE, width = "100%")
  })
  output$uiGroup2 <- renderUI({
    req(reactive_checkpoint())
    selectInput(inputId = ns("group2"), "group 2", choices = choices()$group, selected = htv2(), selectize = TRUE, width = "100%")
  })

  # output$testResult <- renderUI({
  output$testResult <- DT::renderDataTable({
    req(reactive_checkpoint())
    req(input$group1)
    req(input$group2)
    req(x <- choices()$x)
    req(f <- choices()$f)
    r1 <- try(t.test(x[f == input$group1], x[f == input$group2]), silent = TRUE)
    req(inherits(r1, "htest"))    
    r2 <- wilcox.test(x[choices()$f == input$group1], x[choices()$f == input$group2]) 
    df <- data.frame(
      "Diff" = signif(r1$estimate[1] - r1$estimate[2], digits = 3), 
      "P t-test" = signif(r1$p.value, digits = 3), 
      "P MVU-test" = signif(r2$p.value, digits = 3), 
      check.names = FALSE, row.names = NULL
    )
    DT::datatable( df , options = list(searching = FALSE, lengthChange = FALSE, dom = 't'), rownames = FALSE, class = "compact")
  })
  
  ################## dynamic UI for tickbox ###################
  output$regTickBox <- renderUI({
    req(reactive_checkpoint())
    req(hm()$scatter)
    checkboxInput(ns("showRegLine"), "Regression line", reactive_regLine())
  })
  
  ################## render plot ###################
  # update source
  reactive_param_plotly_scatter_src <- reactive({
    x <- reactive_param_plotly_scatter()
    src <- ifelse ( !is.null(x$source), x$source, 'scatterplotly')
    x$source <- src
    x
  })
  
  plotter <- reactive({
    
    req(reactive_checkpoint())
    
    # if beeswarm, return the object without need of input$showRegLine 
    if (!hm()$scatter) {
      return(
        do.call(plotly_scatter, args = c(
          reactive_param_plotly_scatter_src(), regressionLine = FALSE #, drawButtonId = ns("testComp")
        ))
      )
    }
    req(!is.null(input$showRegLine))
    do.call(plotly_scatter, args = c(
      reactive_param_plotly_scatter_src(), regressionLine = input$showRegLine #, drawButtonId = ns("testComp")
    ))
  })
  output$plotly.scatter.output <- renderPlotly({
    req( plotter()$fig )
    plotter()$fig 
  })
  
  # add a button to save figure data for later editting
  # disabled currently
  # #################### add plot data ####################
  # figureId <- eventReactive(input$testComp, {
  #   avl <- ls(envir = .GlobalEnv, pattern = "^.__plotData__", all.names = TRUE)
  #   if (length(avl) == 0) {
  #     nplot <- 1
  #   } else {
  #     dup <- vapply(avl, function(name) {
  #       ob <- get(name, envir = .GlobalEnv)
  #       identical(ob, plotter()$data)
  #     }, logical(1))
  #     if (any(dup)) return("duplicated")
  #     plotcum <- as.integer(sub("^.__plotData__", "0", avl))
  #     nplot <- max(plotcum)+1
  #   }
  #   paste0(".__plotData__", nplot)
  # })

  # observeEvent(figureId(), {
  #   if (figureId() == "duplicated") {
  #     showModal(modalDialog(
  #       "Figure data has been added!", footer = modalButton("Dismiss")
  #     ))
  #   } else {      
  #     showModal( modalDialog(
  #         "Figure name",
  #         textInput(inputId = ns("fname"), label = "Figure name", placeholder = "Give figure name"),
  #         actionButton(inputId = ns("savefname"), label = "Save for later editting!"),
  #         easyClose = TRUE,
  #         footer = NULL
  #       )
  #     )
  #   }
  # })

  # observeEvent(input$savefname, {
  #   req(figureId())
  #   fid <- ifelse(nchar(input$fname) == 0, "Unnamed figure", input$fname)
  #   fata <- plotter()$data
  #   attr(fata, "name") <- fid
  #   attr(fata, "type") <- "scatter"
  #   assign(figureId(), fata, envir = .GlobalEnv)
  #   showModal(modalDialog(
  #     "Figure data has been added!", footer = modalButton("Dismiss"), easyClose = TRUE
  #   ))
  # })  
  
  ################## return selected ###################

  rr <- reactive({
    id <- plotter()$data$index
    
    selected <- event_data("plotly_selected", source = reactive_param_plotly_scatter_src()$source)
    selected <- sort(id[fastmatch::'%fin%'(plotter()$data$xyid,  paste(selected$x, selected$y))])
    
    clicked <- event_data("plotly_click", source = reactive_param_plotly_scatter_src()$source )
    clicked <- sort(id[fastmatch::'%fin%'(plotter()$data$xyid, paste(clicked$x, clicked$y))])
    list(selected = selected, clicked = clicked)
    })

  reactive({
    list(
      selected = rr()$selected,
      clicked = rr()$clicked,
      regline = input$showRegLine,
      htest_V1 = input$group1,
      htest_V2 = input$group2
    )
  })
}


