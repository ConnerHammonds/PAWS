# Admin Module
# Handles data upload, roster management, and user administration

# Module UI
mod_admin_ui <- function(id) {
  ns <- NS(id)
  
  tagList(
    h2("Admin Portal"),
    p("Coaches and administrators can upload data and manage team rosters."),
    
    fluidRow(
      column(6,
        wellPanel(
          h4("Upload Data"),
          fileInput(ns("csv_upload"), "Upload CSV File:",
                   accept = c(".csv", "text/csv")),
          selectInput(ns("data_type"), "Data Type:", 
                     choices = c("Pitch Data", "Hit Data", "Player Roster")),
          actionButton(ns("upload_btn"), "Process Upload", 
                      class = "btn-primary")
        )
      ),
      column(6,
        wellPanel(
          h4("Upload Status"),
          verbatimTextOutput(ns("upload_status"))
        )
      )
    ),
    
    fluidRow(
      column(12,
        h4("Preview Data"),
        tableOutput(ns("preview_table"))
      )
    ),
    
    hr(),
    
    fluidRow(
      column(12,
        h4("Roster Management"),
        p("Player roster management features coming in Phase 3.")
      )
    )
  )
}

# Module Server
mod_admin_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    
    # Store uploaded data
    uploaded_data <- reactiveVal(NULL)
    
    # Handle file upload
    observeEvent(input$csv_upload, {
      req(input$csv_upload)
      
      tryCatch({
        data <- read.csv(input$csv_upload$datapath)
        uploaded_data(data)
        
        output$upload_status <- renderText({
          paste0("File loaded successfully!\n",
                "Rows: ", nrow(data), "\n",
                "Columns: ", ncol(data))
        })
      }, error = function(e) {
        output$upload_status <- renderText({
          paste0("Error loading file:\n", e$message)
        })
      })
    })
    
    # Process upload button
    observeEvent(input$upload_btn, {
      req(uploaded_data())
      
      # TODO: Phase 3 - Implement database insertion logic
      output$upload_status <- renderText({
        paste0("Upload processing not yet implemented.\n",
              "This will be completed in Phase 3.\n\n",
              "Current file: ", input$csv_upload$name)
      })
    })
    
    # Preview uploaded data
    output$preview_table <- renderTable({
      req(uploaded_data())
      head(uploaded_data(), 10)
    })
  })
}
