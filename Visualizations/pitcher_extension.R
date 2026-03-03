pitcher_extension <- function(df) {

  #validation
  required_cols <- c("Extension", "Release_Height", "Pitch_Type")
  missing_cols  <- setdiff(required_cols, names(df))
  if (length(missing_cols) > 0) {
    stop(
      "Extension plot requires the following columns: ",
      paste(missing_cols, collapse = ", ")
    )
  }

  # axis
  axis_x_limits <- c(0, 120)
  axis_y_limits <- c(0, 100)

  # plot
  p <- ggplot(
    df,
    aes(
      x = as.numeric(as.character(Extension)) * 12,
      y = as.numeric(as.character(Release_Height)) * 12,
      color = Pitch_Type
    )
  ) +
    # interactive points
    geom_point_interactive(
      aes(
        tooltip = paste0(
          "Extension: ", round(as.numeric(as.character(Extension)) * 12, 1), " in\n",
          "Release Height: ", round(as.numeric(as.character(Release_Height)) * 12, 1), " in"
        )
      ),
      size = 3,
      alpha = 0.85
    ) +
    # Axis
    scale_x_continuous(
      limits = axis_x_limits,
      breaks = seq(0, 120, by = 12),
      expand = c(0, 0)
    ) +
    scale_y_continuous(
      limits = axis_y_limits,
      breaks = seq(0, 100, by = 12),
      expand = c(0, 0)
    ) +

    coord_fixed(ratio = 1) +

    # pitch colors
    scale_color_manual(values = PITCH_COLORS, na.value = "grey50") +

    #label
    labs(
      title = "Pitch Extension",
      x = "Extension (in)",
      y = "Release Height (in)",
      color = NULL
    ) +

    # Theme 
    theme_minimal(base_size = 13) +
    theme(
      plot.title        = element_text(hjust = 0.5, face = "plain", size = 14),
      panel.grid.major  = element_line(color = "grey88", linewidth = 0.4),
      panel.grid.minor  = element_blank(),
      panel.background  = element_rect(fill = "white", color = NA),
      plot.background   = element_rect(fill = "white", color = NA),
      legend.position   = "right",
      legend.title      = element_blank(),
      legend.key        = element_rect(fill = "white", color = NA),
      legend.text       = element_text(size = 11),
      axis.text         = element_text(size = 9),
      axis.title        = element_text(size = 11)
    )

  # girafe for interactivity
  girafe(
    ggobj = p,
    options = list(
      opts_tooltip(
        css = "background-color:#222; color:#fff; padding:6px 10px; border-radius:4px; font-size:12px; white-space:pre;",
        use_cursor_pos = TRUE
      ),
      opts_hover(css = "opacity:1; r:5px;")
    )
  )

}