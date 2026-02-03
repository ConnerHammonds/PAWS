mod_pitching_ui <- function(id) {
  ns <- NS(id)
  
  tagList(
    fluidRow(
      column(
        width = 6,
        div(
          style = "background-color: #353535; padding: 20px; border-radius: 10px;",
          fileInput(ns("csv_upload"), "Upload CSV"),
          selectInput(ns("select_pitcher"), "Select Pitcher", choices = NULL),
          actionButton(ns("generate_report"), "Generate Report")
        )
      ),
      column(
        width = 6,
        div(
          style = "background-color: #2b2b2b; padding: 20px; border-radius: 10px; height: calc(100vh - 260px); overflow: auto;",
          tabsetPanel(
            id = ns("right_tabs"),
            type = "pills",
            tabPanel("Pitch Movement", uiOutput(ns("pitch_movement"))),
            tabPanel("Pitch Location", uiOutput(ns("pitch_location"))),
            tabPanel("Release Height", uiOutput(ns("release_height"))),
            tabPanel("Extension", uiOutput(ns("extension")))
          )
        )
      )
    ),
    fluidRow(
      style = "margin-top: 175px;",
      column(
        width = 12,
        div(
          style = "background-color: #353535; padding: 20px; border-radius: 10px;",
          h4("Pitch Data"),
          tableOutput(ns("pitch_data_table"))
        )
      )
    )  
  )
}
# Pitching Module Server
mod_pitching_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    
    # Read CSV
    csv_data <- reactive({
      req(input$csv_upload)
      read.csv(input$csv_upload$datapath, stringsAsFactors = FALSE)
    })
    
    # Update dropdown with unique pitcher names
    observeEvent(csv_data(), {
      updateSelectInput(session, "select_pitcher", choices = unique(csv_data()$Pitcher))
    })
    # Filter for selected pitcher
    filtered_data <- reactive({
      req(csv_data(), input$select_pitcher)
      subset(csv_data(), Pitcher == input$select_pitcher)
    })   
    # Render the filtered data table
    output$pitch_data_table <- renderTable({
      req(filtered_data())
      filtered_data()
    }) 
  })
}
