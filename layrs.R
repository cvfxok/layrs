library(sf)
library(tmap)
library(shiny)
library(shinydashboard)
library(bs4Dash)
library(shinydashboardPlus)
library(tigris)
library(colourpicker)

wi_co <- counties(55, cb = TRUE) %>% # debug data
  st_transform(4326)

ca_co <- counties(06, cb = TRUE) %>% # debug data
  st_transform(4326)

ui <- dashboardPage(
    header = dashboardHeader(title = 'layrs'), # page header
    options = list(sidebarExpandOnHover = FALSE), # global page options
    controlbar = dashboardControlbar(
      fileInput('layer1', 'Choose Geospatial Data', # file upload in control bar
                multiple = FALSE,
                accept = c('.geojson', '.kml')),
      actionButton('add-layer', 'placeholder')), # work in progress -- not functonal
    sidebar = dashboardSidebar(
      colourInput('col', 'Fill Color', 'purple'), # fill color picker
      colourInput('bcol', 'Border Color', 'Black'), # border color picker
      sliderInput('alpha', 'Opacity', min = 0, max = 100, value = 100, step = 0.1), # opacity slide
      numericInput('lwd', 'Border Width', value = 1) # border width
    ),
    body = dashboardBody(
        tmapOutput("userMap", height = "700px") # map output perameters
    )
)
server <- function(input, output) {
  output$userMap <- renderTmap({ # render the map
    req(input$layer1)
    tm_shape(shp = st_read(input$layer1[4])) + # reactivity for user inputs
      tm_polygons(col = input$col, border.col = input$bcol, alpha=((input$alpha)/100), lwd = input$lwd)
  })
}

shinyApp(ui = ui, server = server)