# Pitching Analytics Module
# Displays pitch-level data, heat maps, and velocity trends

# Module UI
mod_pitching_ui <- function(id) {
  ns <- NS(id)
  
  tagList(
    h2("Pitching Analytics"),
    
    fluidRow(
      column(4,
        wellPanel(
          h4("Filters"),
          selectInput(ns("pitcher"), "Select Pitcher:", choices = c("All Pitchers")),
          dateRangeInput(ns("date_range"), "Date Range:",
                        start = Sys.Date() - 30,
                        end = Sys.Date()),
          selectInput(ns("pitch_type"), "Pitch Type:", 
                     choices = c("All", "Fastball", "Curveball", "Slider", "Changeup"))
        )
      ),
      column(8,
        tabsetPanel(
          tabPanel("Heat Map",
            plotOutput(ns("pitch_heatmap"), height = "400px")
          ),
          tabPanel("Velocity Trends",
            plotOutput(ns("velocity_plot"), height = "400px")
          ),
          tabPanel("Spin Rate",
            plotOutput(ns("spin_plot"), height = "400px")
          ),
          tabPanel("Pitch Location",
            plotOutput(ns("pitch_location_plot"), width = "600px", height = "600px")
          )
        )
      )
    ),
    
    fluidRow(
      column(12,
        h4("Pitch Data"),
        tableOutput(ns("pitch_table"))
      )
    )
  )
}

# Module Server
mod_pitching_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    
    # Placeholder data (will be replaced with DB queries)
    pitch_data <- reactive({
      # TODO: Query database based on filters
      data.frame(
        Date = Sys.Date(),
        Pitcher = "Sample Player",
        PitchType = "Fastball",
        Velocity = 92.5,
        SpinRate = 2400,
        stringsAsFactors = FALSE
      )
    })
    
    # Heat Map Output
    output$pitch_heatmap <- renderPlot({
      ggplot() +
        annotate("text", x = 0.5, y = 0.5, 
                label = "Pitch heat map\n(Coming in Phase 4)", 
                size = 8, color = "gray50") +
        theme_void()
    })
    
    # Velocity Trend Plot
    output$velocity_plot <- renderPlot({
      ggplot() +
        annotate("text", x = 0.5, y = 0.5, 
                label = "Velocity trends\n(Coming in Phase 4)", 
                size = 8, color = "gray50") +
        theme_void()
    })
    
    # Spin Rate Plot
    output$spin_plot <- renderPlot({
      ggplot() +
        annotate("text", x = 0.5, y = 0.5, 
                label = "Spin rate analysis\n(Coming in Phase 4)", 
                size = 8, color = "gray50") +
        theme_void()
    })
    
    # Data Table
    output$pitch_table <- renderTable({
      pitch_data()
    })
    output$pitch_location_plot <- renderPlot({
      # draw grid (inches)
      base <- ggplot() +
        geom_hline(yintercept = seq(0, 72, by = 6), color = "gray85", size = 0.5) +
        geom_vline(xintercept = seq(-36, 36, by = 6), color = "gray85", size = 0.5)

      #data frame for the strike zone in inches
      bottom_in <- 17    # inches above ground
      top_in <- 43       # inches above ground
      xmin_in <- -0.83 * 12
      xmax_in <- 0.83 * 12
      sz <- data.frame(xmin = xmin_in, xmax = xmax_in, ymin = bottom_in, ymax = top_in)

      base +
        geom_rect(data = sz, mapping = aes(xmin = xmin, xmax = xmax, ymin = ymin, ymax = ymax),
            fill = "purple", alpha = 0.35, color = "black", size = 1.2, inherit.aes = FALSE) +
        coord_fixed(ratio = 1) +    # keep one unit = one unit
        scale_x_continuous(breaks = seq(-36, 36, by = 6), limits = c(-36, 36), expand = c(0, 0)) +
        scale_y_continuous(breaks = seq(0, 72, by = 6), limits = c(0, 72), expand = c(0, 0)) +
        labs(
          title = "Strike Zone (Placeholder)",
          x = "Horizontal Location (inches)",
          y = "Vertical Location (inches)"
        ) +
        theme_minimal() +
        theme(panel.grid = element_blank())
    })
  })
}
