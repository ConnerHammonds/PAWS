# =============================================================================
# arm_release_angle.R
#
# Purpose : Build a reusable arm release angle scatter plot.
# Inputs  : A data frame with at minimum the columns:
#             - Release_Side   (numeric, inches from center of rubber)
#             - Release_Height (numeric, inches above ground)
#             - Pitch_Type     (character / must match keys in PITCH_COLORS)
#
# Output  : A ggplot object showing release point positions by pitch type.
# =============================================================================

arm_release_angle <- function(data) {

  # Input validation

  required_cols <- c("Release_Side", "Release_Height", "Pitch_Type")
  missing_cols  <- setdiff(required_cols, names(data))
  if (length(missing_cols) > 0) {
    stop(
      "Arm release angle plot requires the following columns: ",
      paste(missing_cols, collapse = ", ")
    )
  }

  # Convert to numeric
  data$Release_Side   <- as.numeric(data$Release_Side)
  data$Release_Height <- as.numeric(data$Release_Height)

  # Remove rows with NA release data
  data <- data[!is.na(data$Release_Side) & !is.na(data$Release_Height), ]

  # Build the plot
  p <- ggplot(data, aes(
    x     = Release_Side,
    y     = Release_Height * 12,
    color = Pitch_Type
  )) +
    geom_point(size = 3, alpha = 0.85) +
    scale_color_manual(values = PITCH_COLORS, na.value = "grey50") +
    labs(
      title = "Arm Release Angle",
      x     = "Release Side (ft)",
      y     = "Release Height (in)",
      color = NULL
    ) +
    theme_minimal(base_size = 13) +
    theme(
      plot.title       = element_text(hjust = 0.5, face = "plain", size = 14),
      panel.grid.major = element_line(color = "grey88", linewidth = 0.4),
      panel.grid.minor = element_blank(),
      panel.background = element_rect(fill = "white", color = NA),
      plot.background  = element_rect(fill = "white", color = NA),
      legend.position  = "right",
      legend.title     = element_blank(),
      legend.key       = element_rect(fill = "white", color = NA),
      legend.text      = element_text(size = 11),
      axis.text        = element_text(size = 9),
      axis.title       = element_text(size = 11)
    )

  p
}
