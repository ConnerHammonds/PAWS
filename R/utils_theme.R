# Theme Utility Functions
# Functions for dynamic branding and theming

# Get team theme from database
get_team_theme <- function(pool, team_id) {
  # TODO: Implement once database is set up (Phase 2)
  
  # Return default SBU theme for now
  list(
    primary = "#4F2683",    # SBU Purple
    secondary = "#FFFFFF",  # White
    accent = "#222222",     # Dark Gray
    team_name = "SBU Bearcats"
  )
}

# Create bslib theme from team colors
create_app_theme <- function(primary_color, secondary_color, accent_color) {
  bslib::bs_theme(
    version = 5,
    bg = "#FFFFFF",
    fg = "#222222",
    primary = primary_color,
    secondary = secondary_color,
    base_font = bslib::font_google("Roboto"),
    heading_font = bslib::font_google("Roboto Slab", wght = c(400, 700))
  )
}

# Apply theme to app
apply_dynamic_theme <- function(session, theme_colors) {
  # TODO: Implement dynamic theme switching (Phase 2)
  # This will use bslib::bs_theme_update() to change colors on the fly
  
  message("Dynamic theming not yet implemented")
}

# ---------------------------------------------------------------------------
# Pitch-type color palette  (Statcast abbreviations)
# Keys match the Pitch_Type values that come directly out of the CSV.
# Used by every pitch visualization in the project.  Edit once here and all
# plots update automatically.  Unknown abbreviations fall back to grey.
# ---------------------------------------------------------------------------
PITCH_COLORS <- c(
  "FF" = "#D55E00",  # 4-Seam Fastball  — burnt orange
  "FT" = "#E69F00",  # 2-Seam Fastball  — amber
  "SI" = "#56B4E9",  # Sinker           — light blue
  "FC" = "#F0E442",  # Cutter           — yellow
  "SL" = "#4CAF50",  # Slider           — green
  "CU" = "#0072B2",  # Curveball        — blue
  "CH" = "#9B59B6",  # Changeup         — purple
  "SP" = "#CC79A7",  # Splitter         — pink
  "KN" = "#999999",  # Knuckleball      — grey
  "EP" = "#A52A2A"   # Eephus           — brown
)

