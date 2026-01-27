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
    #server logic
  })
}
