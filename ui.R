# Baseball Analytics Dashboard - UI Definition
# This file defines the user interface structure

library(shiny)
library(bslib)

# Define app theme (SBU colors)
app_theme <- bs_theme(
  version = 5,
  bg = "#dedede",
  fg = "#222222",
  primary = "#492779",    # SBU Purple
  secondary = "#FFFFFF",
  base_font = font_google("Roboto"),
  heading_font = font_google("Roboto Slab", wght = c(400, 700))
)

# Define UI
page_navbar(
  title = "SBU Baseball Analytics",
  theme = app_theme,
  bg = "#353535",
  
  # Navigation tabs
  nav_panel(
    title = "Pitching",
    icon = icon("baseball"),
    mod_pitching_ui("pitching")
  ),
  
  nav_panel(
    title = "Hitting",
    icon = icon("baseball-bat-ball"),
    mod_hitting_ui("hitting")
  ),
  
  nav_panel(
    title = "Admin",
    icon = icon("user-shield"),
    mod_admin_ui("admin")
  ),
  
  # Spacer and info
  nav_spacer(),
  
  nav_item(
    tags$span(
      style = "padding: 8px;",
      "v0.1.0"
    )
  )
)
