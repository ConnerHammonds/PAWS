# Hitting Module UI
mod_hitting_ui <- function(id) {
  ns <- NS(id)
  
  tagList(
    fluidRow(
      column(
        width = 6,
        div(
          style = "background-color: #353535; padding: 20px; border-radius: 10px;",
          fileInput(ns("csv_upload"), "Upload CSV"),
          selectInput(ns("select_hitter"), "Select Hitter", choices = NULL),
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
            tabPanel("Spray Chart", uiOutput(ns("spray_chart"))),
            tabPanel("Exit Velocity", uiOutput(ns("exit_velocity"))),
            tabPanel("Heat Map", uiOutput(ns("heat_map_hitter"))),
            tabPanel("Launch Angle", uiOutput(ns("launch_angle")))
          )
        )
      )
    ),
    fluidRow(
      column(
        style = "margin-top: 175px;",
        width=12,
        div(
        style = "background-color: #353535; padding: 20px; border-radius: 10px;",
        h4("Hitter Data"),
        tableOutput(ns("hitter_data_table"))
        )
      )
    )
  )
}

# Hitting Module Server
mod_hitting_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    
    # Read CSV
    csv_data <- reactive({
      req(input$csv_upload)
      read.csv(input$csv_upload$datapath, stringsAsFactors = FALSE)
    })
    
    # Update dropdown with unique hitter names
    observeEvent(csv_data(), {
      updateSelectInput(session, "select_hitter", choices = unique(csv_data()$Hitter))
    })
    
    # Filter for selected hitter
    filtered_data <- reactive({
      req(csv_data(), input$select_hitter)
      subset(csv_data(), Hitter == input$select_hitter)
    })
    
    # Render the filtered data table
    output$pitch_data_table <- renderTable({
      req(filtered_data())
      filtered_data()
    })
    
  })
}
