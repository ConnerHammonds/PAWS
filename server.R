# Baseball Analytics Dashboard - Server Logic
# This file defines the server-side functionality

library(shiny)

# Define server logic
function(input, output, session) {
  
  # Initialize modules
  mod_pitching_server("pitching")
  mod_hitting_server("hitting")
  mod_admin_server("admin")
  
  # Session management and cleanup
  session$onSessionEnded(function() {
    # Clean up any session-specific resources
    message("User session ended")
  })
}
