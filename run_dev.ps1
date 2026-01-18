# Development Server Startup Script (PowerShell)
# Usage: .\run_dev.ps1

Write-Host "Starting Baseball Analytics Dashboard in DEVELOPMENT mode..." -ForegroundColor Green

# Set environment
$env:R_CONFIG_ACTIVE = "development"

# Run app
Rscript -e "shiny::runApp(port = 3838, host = '0.0.0.0', launch.browser = TRUE)"
