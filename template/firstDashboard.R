rm(list=ls())

#install.packages('shinydashboard')
library(shinydashboard)
library(shiny)

starwars_url = 'http://s3.amazonaws.com/assets.datacamp.com/production/course_6225/datasets/starwars.csv'

header <- dashboardHeader(
  dropdownMenu(
    type = "messages",
    messageItem(
      from = "Lucy",
      message = "You can view the International Space Station!",
      href = "https://spotthestation.nasa.gov/sightings/"
    ),
    # Add a second messageItem() 
    messageItem(
      from = "Omar",
      message = "Learn more about the International Space Station",
      href = "https://spotthestation.nasa.gov/faq.cfm"
    )
  ),
  dropdownMenu(
    type = 'notifications',
    notificationItem(
      text = 'The International Space Station is overhead!'
    )
  ),
  dropdownMenu(
    type = 'tasks',
    taskItem(
      text = 'Mission Learn Shiny Dashboard',
      value = 10
    )
  )
)

sidebar <- dashboardSidebar(
  sidebarMenu(
    # Create two `menuItem()`s, "Dashboard" and "Inputs"
    menuItem('Dashboard',
             tabName = 'dashboard'
    ),
    menuItem('Inputs',
             tabName = 'inputs'
    )
  ),
  sliderInput(
    inputId = "height",
    label = "Height",
    min = 66,
    max = 264,
    value = 264,
  ),
  selectInput(
    inputId = "name",
    label = "Name",
    choices = c("Patricia","Carlos","Jocelyn","Omar")
  )
)

body <- dashboardBody(
  tabItems(
    # Add two tab items, one with tabName "dashboard" and one with tabName "inputs"
    tabItem(
      tabName = "dashboard",
      tabBox(
        title = 'International Space Station fun Facts',
        tabPanel('Fun Fact 1'),
        tabPanel('Fun Fact 2')
      )
    ),
    tabItem(tabName = "inputs")
  ),
  textOutput(
    outputId = "name",
  ),
  tableOutput("table")
)

ui <- dashboardPage(header = header,
                    sidebar = sidebar,
                    body = body
)

server <- function(input, output, session) {
  output$name <- renderText({
    input$name
  })
  
  reactive_starwars_data <- reactiveFileReader(
    intervalMillis = 1000,
    session = session,
    filePath = starwars_url,
    readFunc = function(filePath) { 
      read.csv(url(filePath))
    }
  )
  
  output$table <- renderTable({
    reactive_starwars_data()
  })
}

shinyApp(ui, server)

## LINKS
# Performance! https://www.rstudio.com/resources/videos/profiling-and-performance/
