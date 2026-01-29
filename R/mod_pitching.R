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
          uiOutput(ns("right_panel"))
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
