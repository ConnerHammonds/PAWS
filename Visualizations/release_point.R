#Pitcher release visualization file
release_point<-function(df){
    #validation
  required_cols <- c("Release_Side", "Release_Height", "Pitch_Type")
  missing_cols  <- setdiff(required_cols, names(df))
  if (length(missing_cols) > 0) {
    stop(
      "Release Point plot requires the following columns: ",
      paste(missing_cols, collapse = ", ")
    )
  }
  #axis
  axis_x_limits <- c(-50, 50)
  axis_y_limits <- c(0, 100)

    #init base plot with grid
  base <- ggplot(
    df,
    aes(
      x = as.numeric(as.character(Release_Side)),
      y = as.numeric(as.character(Release_Height)) * 12,
      color = Pitch_Type
    )
  )+
    # interactive points
    geom_point_interactive(
      aes(
        tooltip = paste0(
          "Release Side: ", round(as.numeric(as.character(Release_Side)), 1), " in\n",
          "Release Height: ", round(as.numeric(as.character(Release_Height)) * 12, 1), " in"
        )
      ),
      size = 3,
      alpha = 0.85
    )+ 
    #axis
    scale_x_continuous(
      limits = axis_x_limits,
      breaks = seq(-50, 50, by = 10),
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
      title="Release Point",
      x = "Release Side (from center of rubber)",
      y = "Release Height",
      color=NULL
    ) +
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
  #giraffe for interactivity
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