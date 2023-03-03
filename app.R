library(shiny)
library(shinyBS)
library(shinyWidgets)
library(leaflet)
library(mapBliss)

ui <- fluidPage(
    navbarPage("My Application",
               tabPanel("Plot Flight Route",
                        fluidRow(
                          column(
                            2,
                            actionButton("addFlight", "Add Location"),
                          ),
                          column(10, 
                                 actionButton("plotFlightRoute","Plot Flight Route"),
                                 leafletOutput("flightRoutePlot"))
                        )),
               tabPanel("Plot Road Trip",
                        sidebarPanel(
                          actionButton("addFlight", "Add Location")
                        ),
                        mainPanel()),
               tabPanel("Plot Hybrid Route",
                        sidebarPanel(
                          actionButton("addFlight", "Add Location")
                        ),
                        mainPanel()),
               tabPanel("Plot City View",
                        fluidRow(
                          column(
                            2,
                            textInput("cityView","Type City Name"),
                            selectInput("cityTheme",
                                        "Choose Theme",
                                        choices = c("OpenStreetMap",
                                                    "Watercolors"),
                                        selected = "OpenStreetMap")
                            ),
                        column(10, 
                               actionButton("plotCityView","Plot City View"),
                               br(),
                               br(),
                               leafletOutput("cityViewPlot"))
                        )
               )
              )
)

server <- function(input, output, session) {
  
  observeEvent(input$addFlight, {
    insertUI(
      selector = "#addFlight",
      where = "afterEnd",
      ui = list(
      textInput(paste0("addFlight", input$addFlight),"",width="50%"),
      actionButton(paste0("removeFlight",input$addFlight),
                   label="",
                   icon=icon("trash"),
                   onclick=paste0('var $btn=$(this); 
                                  setTimeout(function(){
                                                        $btn.remove();
                                                        document.getElementById("addFlight',input$addFlight,'").remove();
                                                        },0);')
      )
    )
    )
  }
  )
  
  observeEvent(input$plotFlightRoute,{
    output$plotFlightRoute <- renderLeaflet({
      
    })
  })
  
  
  observeEvent(input$plotCityView,{
    
    cityView<- input$cityView
    theme <- switch(input$cityTheme,
                    "OpenStreetMap" = "//{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                    "Watercolors" = "https://stamen-tiles.a.ssl.fastly.net/watercolor/{z}/{x}/{y}.jpg")
    output$cityViewPlot <- renderLeaflet({
      mapBliss::plot_city_view(cityView,
                               mapBoxTemplate = theme)
    })
  })
}

shinyApp(ui = ui, server = server)
