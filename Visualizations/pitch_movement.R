data <- read.csv("example_bullpen.csv", stringsAsFactors = FALSE)

movement_plot <- function(data) {
  
  ggplot(data, aes(x = Break_Horizontal, y = Break_Vertical, color = Pitch_Type)) +
    geom_point(size = 3, alpha = 0.8) +
    theme_minimal() +
    labs(
      title = "Pitch Movement Chart",
      x = "Horizontal movement, in",
      y = "Vertical movement, in",
      color = "Pitch Type"
    ) +
    theme(
      plot.title = element_text(hjust = 0.5)
    )
}