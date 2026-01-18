# Global Setup - Baseball Analytics Dashboard
# This file loads once when the app starts

# Load environment variables from .env file (if exists)
if (file.exists(".env")) {
  readRenviron(".env")
}

# Load required libraries
library(shiny)
library(bslib)
library(dplyr)
library(ggplot2)
library(DBI)
library(pool)
library(config)

# Load configuration for current environment
app_config <- config::get()

# Source all module files
source("R/mod_pitching.R")
source("R/mod_hitting.R")
source("R/mod_admin.R")
source("R/utils_db.R")
source("R/utils_theme.R")

# Database Connection Pool
# Uncomment when PostgreSQL is configured
# db_pool <- tryCatch({
#   pool::dbPool(
#     drv = RPostgres::Postgres(),
#     dbname = app_config$database$dbname,
#     host = app_config$database$host,
#     port = app_config$database$port,
#     user = Sys.getenv("DB_USER"),
#     password = Sys.getenv("DB_PASSWORD"),
#     minSize = 1,
#     maxSize = app_config$database$pool_size
#   )
# }, error = function(e) {
#   message("Failed to establish database connection: ", e$message)
#   NULL
# })

# App Configuration
APP_TITLE <- app_config$app$title
APP_VERSION <- app_config$app$version

# Default Theme (from config)
SBU_PRIMARY <- app_config$theme$primary_color
SBU_SECONDARY <- app_config$theme$secondary_color
SBU_ACCENT <- app_config$theme$accent_color

# Set maximum file upload size (in MB from config)
options(shiny.maxRequestSize = app_config$app$max_upload_size * 1024^2)

# Clean up on app stop
onStop(function() {
  # Close database pool when app stops (uncomment when DB is configured)
  # if (exists("db_pool") && !is.null(db_pool)) {
  #   pool::poolClose(db_pool)
  # }
})
