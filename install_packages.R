# Baseball Analytics Dashboard - Package Dependencies
# Run this script to install all required packages for the project
# Usage: source("install_packages.R")

# List of required packages
required_packages <- c(
  # Core Shiny & Database
  "shiny",           # Web application framework
  "DBI",             # Database interface
  "RPostgres",       # PostgreSQL driver
  "pool",            # Database connection pooling
  
  # UI & Theming
  "bslib",           # Bootstrap 5 theming
  "thematic",        # Auto-themed visualizations
  "shinymanager",    # Authentication & user management
  
  # Visualization
  "ggplot2",         # Grammar of graphics
  "plotly",          # Interactive plots
  
  # Data Manipulation
  "dplyr",           # Data wrangling
  "tidyr",           # Data tidying
  "readr",           # Fast CSV reading
  
  # Additional utilities
  "glue",            # String interpolation
  "lubridate",       # Date/time handling
  "jsonlite"         # JSON parsing
)

# Set CRAN mirror
options(repos = c(CRAN = "https://cloud.r-project.org"))

# Function to install missing packages
install_if_missing <- function(packages) {
  installed <- installed.packages()[, "Package"]
  missing <- packages[!packages %in% installed]
  
  if (length(missing) > 0) {
    cat("Installing missing packages:", paste(missing, collapse = ", "), "\n")
    install.packages(missing, dependencies = TRUE)
    cat("Installation complete!\n")
  } else {
    cat("All required packages are already installed.\n")
  }
}

# Install missing packages
install_if_missing(required_packages)

# Verify installation
cat("\n=== Package Verification ===\n")
for (pkg in required_packages) {
  status <- if (requireNamespace(pkg, quietly = TRUE)) "✓" else "✗"
  cat(sprintf("%s %s\n", status, pkg))
}

cat("\nSetup complete! You're ready to start development.\n")
