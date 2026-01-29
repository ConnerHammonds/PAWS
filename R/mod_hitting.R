# Hitting Module UI
mod_hitting_ui <- function(id) {
  ns <- NS(id)
  
  tagList(
    fluidRow(
      column(
        width = 4,
        div(
          style = "background-color: #353535; padding: 20px; border-radius: 10px;",
          fileInput(ns("csv_upload"), "Upload CSV"),
          selectInput(ns("select_hitter"), "Select Hitter", choices = NULL),
          actionButton(ns("generate_report"), "Generate Report")
        )
      )
    ),
    fluidRow(
      column(
        width=12,
        div(
        style = "background-color: #353535; padding: 20px; border-radius: 10px;",
        h4("Pitch Data"),
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
