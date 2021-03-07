rm(list=ls())

#install.packages('shinydashboard')
library(shinydashboard)
library(shiny)

# Create fake tasks
text = c('Las estadísiticas dicen que no le has dato de comer al perro. Dale.',
         'Contruye un dashboarde bien bonito de empleos.',
         'Tómate tus medicinas para las muelas.')
value = c(0,
          15,
          100)
task_data = data.frame(text,value)

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
  dropdownMenuOutput("task_menu")
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
  ),
  actionButton("click", "Update click box")
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
  tableOutput("table"),
  valueBoxOutput("click_box"),
  # Row 1
  fluidRow(
    box(
      width = 12,
      title = "Regular Box, Row 1",
      "Star Wars"
    )
  ),
  # Row 2
  fluidRow(
    box(
      width = 12,
      title = "Regular box, Row 2",
      "Nothing but Star Wars"
    )
  ),
  # Column 1
  fluidRow(
      column(width = 6,
       infoBox(
         width = NULL,
         title = "Regular Box, Column 1",
         subtitle = "Gimme those Star Wars"
       )
      ),
      # Column 2
      column(width = 6,
       infoBox(
         width = NULL,
         title = "Regular Box, Column 2",
         subtitle = "Don't let them end"
       )
      )
    )
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
  
  output$task_menu <- renderMenu({
    tasks <- apply(task_data, 1, function(row) {
      taskItem(text = row[["text"]],
               value = row[["value"]])
    })
    dropdownMenu(type = "tasks", .list = tasks)
  })
  
  output$click_box <- renderValueBox({
    valueBox(
      value = input$click,
      subtitle = "Click Box"
    )
  })
}

shinyApp(ui, server)

## LINKS
# Performance! https://www.rstudio.com/resources/videos/profiling-and-performance/
