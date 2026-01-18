#!/usr/bin/env Rscript
# Development Server Startup Script
# Usage: Rscript run_dev.R

# Set development environment
Sys.setenv(R_CONFIG_ACTIVE = "development")

# Run the app
shiny::runApp(
  port = 3838,
  host = "0.0.0.0",
  launch.browser = TRUE
)
