# =============================================================================
# pitch_movement.R
#
# Purpose : Build a reusable pitch-movement scatter plot.
# Inputs  : A data frame with at minimum the columns:
#             - Break_Horizontal       (numeric, inches)
#             - Break_Induced_Vertical (numeric, inches)
#             - Pitch_Type             (character / Must match keys in PITCH_COLORS)



# Function signature
# `data` is whatever data frame the caller passes in (live CSV upload, a
# reactive data frame from Shiny, a static test frame, etc.).
pitch_movement <- function(data) {
  # Returns a ggiraph girafe object so Shiny can render hover tooltips.

  # Input validation
  # Fail early with a clear message rather than a confusing ggplot2 error.
  required_cols <- c("Break_Horizontal", "Break_Induced_Vertical", "Pitch_Type")
  missing_cols  <- setdiff(required_cols, names(data))
  if (length(missing_cols) > 0) {
    stop(
      "Movement plot requires the following columns to generate this plot: ",
      paste(missing_cols, collapse = ", ")
    )
  }

  # ---------------------------------------------------------------------------
  # Fixed axis parameters (defined once, used in two scale_ calls)
  # Range and break interval match the -30 → 30 / 2.5-inch grid
  # ---------------------------------------------------------------------------
  axis_limits <- c(-30, 30)
  axis_breaks <- seq(-30, 30, by = 2.5)

  # ---------------------------------------------------------------------------
  # Named color palette
  # PITCH_COLORS is defined globally in R/utils_theme.R and sourced via
  # global.R, so it is available app-wide.  Edit colors there once and every
  # pitch visualization updates automatically.
  # ---------------------------------------------------------------------------

  # ---------------------------------------------------------------------------
  # Build the plot
  # ---------------------------------------------------------------------------
  p <- ggplot(data, aes(x = as.numeric(Break_Horizontal), y = as.numeric(Break_Induced_Vertical), color = Pitch_Type)) +

    # Step 5 — Zero reference lines (the cross-hair in the screenshot)
    geom_hline(yintercept = 0, color = "grey40", linewidth = 0.6) +
    geom_vline(xintercept = 0, color = "grey40", linewidth = 0.6) +

    # Step 6 — Interactive scatter points with hover tooltips
    geom_point_interactive(
      aes(
        tooltip = paste0(
          "Horizontal: ", round(as.numeric(Break_Horizontal), 1), " in\n",
          "Vertical: ",   round(as.numeric(Break_Induced_Vertical), 1), " in"
        )
      ),
      size = 3, alpha = 0.85
    ) +

    # Step 7 — Fixed, labeled axes with consistent 2.5-inch grid spacing
    scale_x_continuous(
      limits = axis_limits,
      breaks = axis_breaks,
      expand = c(0, 0)
    ) +
    scale_y_continuous(
      limits = axis_limits,
      breaks = axis_breaks,
      expand = c(0, 0)
    ) +

    # Enforce equal unit spacing on both axes so grid cells are square
    coord_fixed(ratio = 1) +

    # Step 8 — Color scale (PITCH_COLORS defined in R/utils_theme.R)
    scale_color_manual(values = PITCH_COLORS, na.value = "grey50") +

    # Step 9 — Axis and legend labels
    labs(
      title  = "Pitch Movement Chart",
      x      = "Horizontal movement, in",
      y      = "Vertical movement, in",
      color  = NULL          # pitch type labels are self-explanatory in legend
    ) +

    # Step 10 — Theme: clean minimal base + targeted overrides
    theme_minimal(base_size = 13) +
    theme(
      # Center the title
      plot.title        = element_text(hjust = 0.5, face = "plain", size = 14),

      # Subtle major grid lines only (matches screenshot)
      panel.grid.major  = element_line(color = "grey88", linewidth = 0.4),
      panel.grid.minor  = element_blank(),

      # No grey panel background
      panel.background  = element_rect(fill = "white", color = NA),
      plot.background   = element_rect(fill = "white", color = NA),

      # Legend styling
      legend.position   = "right",
      legend.title      = element_blank(),
      legend.key        = element_rect(fill = "white", color = NA),
      legend.text       = element_text(size = 11),

      # Axis text sizing
      axis.text         = element_text(size = 9),
      axis.title        = element_text(size = 11)
    )

  # Wrap the ggplot in a girafe object to enable interactivity
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