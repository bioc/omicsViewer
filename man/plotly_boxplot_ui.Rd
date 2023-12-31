% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/module_boxplot.R
\name{plotly_boxplot_ui}
\alias{plotly_boxplot_ui}
\title{Shiny module for boxplot using plotly - UI}
\usage{
plotly_boxplot_ui(id)
}
\arguments{
\item{id}{id}
}
\value{
a tagList of UI components

a tagList of UI components
}
\description{
Function should only be used for the developers
}
\examples{
if (interactive()) {
  
  library(shiny)
  
  ui <- fluidPage(
    plotly_boxplot_ui("testplotly")
  )
  
  server <- function(input, output, session) {
    
    x <- cbind(matrix(rnorm(10000, mean = 3), 1000, 10), matrix(rnorm(20000), 1000, 20))
    x[sample(1:length(x), size = 0.3*length(x))] <- NA
    rownames(x) <- paste("R", 1:nrow(x), sep = "")
    colnames(x) <- paste("C", 1:ncol(x), sep = "")
    callModule(plotly_boxplot_module, id = "testplotly",
               reactive_param_plotly_boxplot = reactive(list(
                 x = x# , i  = c(4, 20, 80)# , highlight = c(1, 4, 5, 20), extvar = 1:30
               ))
    )
  }
  
  shinyApp(ui, server)
}
}
