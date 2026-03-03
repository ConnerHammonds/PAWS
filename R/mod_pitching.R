#Pitching Module file with UI and Server functions

#Load necessary pitching visualization files
source("Visualizations/pitch_movement.R")
source("Visualizations/strike_plot.R")
source("Visualizations/pitcher_extension.R")
source("Visualizations/release_point.R")

#UI for pitching module
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
          hr(),
          h5("PDF Report Options", style = "color: #FFFFFF;"),
          tags$div(
            style = "color: #FFFFFF;",
            checkboxInput(ns("chk_strike_zone"), "Strike Zone Scatterplot", value = TRUE),
            checkboxInput(ns("chk_pitch_movement"), "Pitch Movement Scatterplot", value = TRUE),
            checkboxInput(ns("chk_extension"), "Pitcher Extension Chart", value = TRUE),
            checkboxInput(ns("chk_arm_angle"), "Arm Release Angle Chart", value = TRUE)
          ),
          uiOutput(ns("report_button_ui"))
        )
      ),
      column(
        width = 6,
        div(
          style = "background-color: #2b2b2b; padding: 20px; border-radius: 10px; height: calc(100vh - 260px); overflow: auto;",
          tabsetPanel(
            id = ns("right_tabs"),
            type = "pills",
            tabPanel("Pitch Movement", girafeOutput(ns("movement"), width = "100%", height = "auto")),
            tabPanel("Pitch Location", girafeOutput(ns("pitch_location"), width = "100%", height = "auto")),
            tabPanel("Extension", girafeOutput(ns("extension"), width = "100%", height = "auto")),
            tabPanel("Arm Angle", girafeOutput(ns("release_point"), width = "100%", height = "auto"))
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

    # Disable / enable the download button based on data availability
    output$report_button_ui <- renderUI({
      if (!is.null(input$csv_upload) && !is.null(input$select_pitcher) &&
          nchar(input$select_pitcher) > 0) {
        downloadButton(session$ns("download_report"), "Generate PDF Report",
          style = "width: 100%; margin-top: 10px;")
      } else {
        tags$button(
          "Generate PDF Report",
          class    = "btn btn-default shiny-download-link",
          disabled = "disabled",
          style    = "width: 100%; margin-top: 10px; opacity: 0.5; cursor: not-allowed;"
        )
      }
    })

    # Render the filtered data table
    output$pitch_data_table <- renderTable({
      req(filtered_data())
      filtered_data()
    })

    # Pitch location plot (namespaced to module)
    output$pitch_location <- renderGirafe({
      req(filtered_data())
      strike_plot(filtered_data())
    })

    # Pitcher extension plot 
    output$extension <- renderGirafe({
      req(filtered_data())
      pitcher_extension(filtered_data())
    })

    # Pitch Movement plot
    output$movement <- renderGirafe({
      req(filtered_data())
      pitch_movement(filtered_data())
    })

    # Arm Release Angle plot
    output$release_point <- renderGirafe({
      req(filtered_data())
      release_point(filtered_data())
    })

    # --- PDF Report Download Handler ---
    output$download_report <- downloadHandler(
      filename = function() {
        pitcher <- input$select_pitcher
        clean_name <- gsub("[^A-Za-z0-9]", "_", pitcher)
        paste0(clean_name, "_Report_", format(Sys.Date(), "%Y%m%d"), ".pdf")
      },
      content = function(file) {
        # Determine session date from the pitcher's data
        pitcher_df <- filtered_data()
        session_date <- if ("Date" %in% names(pitcher_df) && nrow(pitcher_df) > 0) {
          as.character(pitcher_df$Date[1])
        } else {
          format(Sys.Date(), "%m/%d/%Y")
        }

        # Generate report using pure R graphics (no Pandoc / LaTeX needed)
        generate_pitcher_report(
          output_file     = file,
          pitcher_name    = input$select_pitcher,
          session_date    = session_date,
          pitcher_data    = pitcher_df,
          show_strike_zone    = input$chk_strike_zone,
          show_pitch_movement = input$chk_pitch_movement,
          show_extension      = input$chk_extension,
          show_arm_angle      = input$chk_arm_angle
        )
      }
    )

  })
}
