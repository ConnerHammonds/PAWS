# Strike zone scatter plot generator
strike_plot <- function(df) {
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
        geom_point(data = df, 
                   aes(x = as.numeric(Strike_Zone_Side), 
                       y = as.numeric(Strike_Zone_Height), 
                       color = Pitch_Type), 
                   size = 3) +
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
    }
