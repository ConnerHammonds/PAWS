# Pitching Analytics Module
# Displays pitch-level data, heat maps, and velocity trends

mod_pitching_ui <- function(id) {
  ns <- NS(id)
  tagList(
    fluidRow(
      column(
        width=4,
        div(
          style = "background-color: #353535; padding: 20px; border-radius: 10px;",
          fileInput(ns("csv_upload"), "Upload CSV"),
          selectInput(ns("select_pitcher"), "Select Pitcher", choices = NULL),
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
        tableOutput(ns("pitch_data_table"))
        )
      )
    )
)
}

mod_pitching_server <- function(id) {
  moduleServer(id, function(input, output, session) {

    # Read the CSV file uploaded by the user
    csv_data <- reactive({
      req(input$csv_upload)
      read.csv(input$csv_upload$datapath, stringsAsFactors = FALSE)
    })

    # Update the dropdown with unique pitcher names
    observeEvent(csv_data(), {
      updateSelectInput(session, "select_pitcher", choices = unique(csv_data()$Pitcher))
    })

    # Filter data for the selected pitcher
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

