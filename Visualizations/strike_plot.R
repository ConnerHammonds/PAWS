strike_plot <- function(df) {
  
  #validation
  required_cols <- c("Strike_Zone_Side", "Strike_Zone_Height", "Pitch_Type")
  missing_cols  <- setdiff(required_cols, names(df))
  if (length(missing_cols) > 0) {
    stop(
      "Strike Plot requires the following columns: ",
      paste(missing_cols, collapse = ", ")
    )
  }

  #strike zone box (inches)
  bottom_in <- 17
  top_in    <- 43
  xmin_in   <- -0.83 * 12
  xmax_in   <-  0.83 * 12

  sz <- data.frame(
    xmin = xmin_in,
    xmax = xmax_in,
    ymin = bottom_in,
    ymax = top_in
  )

  #build plot
  base <- ggplot(
    df,
    aes(
      x = as.numeric(Strike_Zone_Side),
      y = as.numeric(Strike_Zone_Height),
      color = Pitch_Type
    )
  ) +

    # interactive points
    geom_point_interactive(
      aes(
        tooltip = paste0(
          "Strike Zone Side: ", round(as.numeric(Strike_Zone_Side), 1), " in\n",
          "Strike Zone Height: ", round(as.numeric(Strike_Zone_Height), 1), " in"
        )
      ),
      size = 3,
      alpha = 0.85
    ) +

    # strike zone box
    geom_rect(
      data = sz,
      aes(xmin = xmin, xmax = xmax, ymin = ymin, ymax = ymax),
      fill = "purple",
      alpha = 0.25,
      color = "black",
      linewidth = 1.2,
      inherit.aes = FALSE
    ) +

    # axis
    scale_x_continuous(
      breaks = seq(-36, 36, by = 6),
      limits = c(-36, 36),
      expand = c(0, 0)
    ) +
    scale_y_continuous(
      breaks = seq(0, 72, by = 6),
      limits = c(0, 72),
      expand = c(0, 0)
    ) +

    coord_fixed(ratio = 1) +

    # colors
    scale_color_manual(values = PITCH_COLORS, na.value = "grey50") +

    labs(
      title = "Strike Zone",
      x = "Horizontal Location (inches)",
      y = "Vertical Location (inches)",
      color = NULL
    ) +
    #theming
    theme_minimal(base_size = 13) +
    theme(
      plot.title        = element_text(hjust = 0.5, size = 14),
      panel.grid.major  = element_line(color = "grey88", linewidth = 0.4),
      panel.grid.minor  = element_blank(),
      panel.background  = element_rect(fill = "white", color = NA),
      plot.background   = element_rect(fill = "white", color = NA),
      legend.position   = "right",
      legend.key        = element_rect(fill = "white", color = NA),
      legend.text       = element_text(size = 11),
      axis.text         = element_text(size = 9),
      axis.title        = element_text(size = 11)
    )
  #girafe for interactivity
  girafe(
    ggobj = base,
    options = list(
      opts_tooltip(
        css = "background-color:#222; color:#fff; padding:6px 10px; border-radius:4px; font-size:12px; white-space:pre;",
        use_cursor_pos = TRUE
      ),
      opts_hover(css = "opacity:1; r:5px;")
    )
  )
}