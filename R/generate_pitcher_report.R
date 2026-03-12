# =============================================================================
# generate_pitcher_report.R
#
# Purpose : Generate a pitcher report PDF using only R's built-in pdf() device,
#           ggplot2, grid, and gridExtra.  No Pandoc or LaTeX required.
#
# Usage   : generate_pitcher_report(output_file, pitcher_name, session_date,
#              pitcher_data, show_strike_zone, show_pitch_movement,
#              show_extension, show_arm_angle)
# =============================================================================

# Pitch-type display name mapping
PITCH_TYPE_NAMES <- c(
  "FF" = "4S Fastball",
  "FT" = "2S Fastball",
  "SI" = "Sinker",
  "FC" = "Cutter",
  "SL" = "Slider",
  "CU" = "Curveball",
  "CH" = "Changeup",
  "SP" = "Splitter",
  "KN" = "Knuckleball",
  "EP" = "Eephus"
)

# ---------------------------------------------------------------------------
# Main entry point
# ---------------------------------------------------------------------------
generate_pitcher_report <- function(output_file,
                                    pitcher_name,
                                    session_date,
                                    pitcher_data,
                                    show_strike_zone    = TRUE,
                                    show_pitch_movement = TRUE,
                                    show_extension      = TRUE,
                                    show_arm_angle      = TRUE) {

  library(ggplot2)
  library(grid)
  library(gridExtra)
  library(dplyr)

  df <- pitcher_data

  # -------------------------------------------------------------------
  # 1.  Build the individual plots that are toggled ON
  # -------------------------------------------------------------------
  plot_list <- list()

  if (show_strike_zone) {
    plot_list[["strike_zone"]] <- .build_strike_zone(df)
  }
  if (show_pitch_movement) {
    plot_list[["pitch_movement"]] <- .build_pitch_movement(df)
  }
  if (show_extension) {
    plot_list[["extension"]] <- .build_extension(df)
  }
  if (show_arm_angle) {
    plot_list[["arm_angle"]] <- .build_arm_angle(df)
  }

  n_charts <- length(plot_list)

  # -------------------------------------------------------------------
  # 2.  Build the summary table as a tableGrob
  # -------------------------------------------------------------------
  table_grob <- .build_summary_table(df)

  # -------------------------------------------------------------------
  # 3.  Compose everything into a single-page PDF
  # -------------------------------------------------------------------
  # Page size: US Letter landscape-ish (11 × 8.5) for room
  pdf(output_file, width = 11, height = 8.5)
  on.exit(dev.off(), add = TRUE)

  # --- Header grobs ---
  header_name <- textGrob(
    pitcher_name,
    gp = gpar(fontsize = 22, fontface = "bold")
  )
  header_date <- textGrob(
    paste("Session Date:", session_date),
    gp = gpar(fontsize = 13)
  )

  # --- Assemble charts grid ---
  if (n_charts > 0) {
    ncol_grid <- min(n_charts, 2)
    nrow_grid <- ceiling(n_charts / 2)
    charts_grob <- arrangeGrob(grobs = plot_list, ncol = ncol_grid, nrow = nrow_grid)
  } else {
    charts_grob <- nullGrob()
  }

  # Heights: header, date, spacer, charts (dominant), spacer, table
  # Relative heights depend on whether charts exist
  if (n_charts > 0) {
    layout <- arrangeGrob(
      header_name,
      header_date,
      charts_grob,
      table_grob,
      ncol    = 1,
      heights = unit(c(0.6, 0.4, 5.0, 2.5), "inches")
    )
  } else {
    layout <- arrangeGrob(
      header_name,
      header_date,
      table_grob,
      ncol    = 1,
      heights = unit(c(0.6, 0.4, 5.0), "inches")
    )
  }

  grid.draw(layout)

  invisible(output_file)
}

# ===========================================================================
# PRIVATE HELPER:  Strike Zone scatter
# ===========================================================================
.build_strike_zone <- function(df) {

  bottom_in <- 17
  top_in    <- 43
  xmin_in   <- -0.83 * 12
  xmax_in   <-  0.83 * 12
  sz <- data.frame(xmin = xmin_in, xmax = xmax_in, ymin = bottom_in, ymax = top_in)

  ggplot() +
    geom_hline(yintercept = seq(0, 72, by = 6), color = "gray85", linewidth = 0.5) +
    geom_vline(xintercept = seq(-36, 36, by = 6), color = "gray85", linewidth = 0.5) +
    geom_point(
      data = df,
      aes(x = as.numeric(Strike_Zone_Side),
          y = as.numeric(Strike_Zone_Height),
          color = Pitch_Type),
      size = 3
    ) +
    geom_rect(
      data = sz,
      aes(xmin = xmin, xmax = xmax, ymin = ymin, ymax = ymax),
      fill = "purple", alpha = 0.35, color = "black",
      linewidth = 1.2, inherit.aes = FALSE
    ) +
    coord_fixed(ratio = 1) +
    scale_x_continuous(breaks = seq(-36, 36, by = 6), limits = c(-36, 36), expand = c(0, 0)) +
    scale_y_continuous(breaks = seq(0, 72, by = 6),   limits = c(0, 72),   expand = c(0, 0)) +
    scale_color_manual(values = PITCH_COLORS, na.value = "grey50") +
    labs(title = "Strike Zone", x = "Horizontal Location (in)", y = "Vertical Location (in)", color = NULL) +
    .report_theme()
}

# ===========================================================================
# PRIVATE HELPER:  Pitch Movement scatter (static — no ggiraph)
# ===========================================================================
.build_pitch_movement <- function(df) {

  ggplot(df, aes(
    x = as.numeric(Break_Horizontal),
    y = as.numeric(Break_Induced_Vertical),
    color = Pitch_Type
  )) +
    geom_hline(yintercept = 0, color = "grey40", linewidth = 0.6) +
    geom_vline(xintercept = 0, color = "grey40", linewidth = 0.6) +
    geom_point(size = 3, alpha = 0.85) +
    scale_x_continuous(limits = c(-30, 30), breaks = seq(-30, 30, by = 5), expand = c(0, 0)) +
    scale_y_continuous(limits = c(-30, 30), breaks = seq(-30, 30, by = 5), expand = c(0, 0)) +
    coord_fixed(ratio = 1) +
    scale_color_manual(values = PITCH_COLORS, na.value = "grey50") +
    labs(title = "Pitch Movement", x = "Horizontal Movement (in)", y = "Induced Vertical Break (in)", color = NULL) +
    .report_theme()
}

# ===========================================================================
# PRIVATE HELPER:  Pitcher Extension scatter
# ===========================================================================
.build_extension <- function(df) {

  ggplot(df, aes(
    x     = as.numeric(Extension) * 12,
    y     = as.numeric(Release_Height) * 12,
    color = Pitch_Type
  )) +
    geom_point(size = 3, alpha = 0.85) +
    scale_color_manual(values = PITCH_COLORS, na.value = "grey50") +
    labs(title = "Pitch Extension", x = "Extension (in)", y = "Release Height (in)", color = NULL) +
    .report_theme()
}
.build_arm_angle <- function(df) {

  ggplot(df, aes(
    x = as.numeric(Release_Side),
    y = as.numeric(Release_Height) * 12,
    color = Pitch_Type
  )) +
    geom_point(size = 3, alpha = 0.85) +
    scale_color_manual(values = PITCH_COLORS, na.value = "grey50") +
    labs(title = "Arm Release Angle", x = "Arm Angle (degrees)", y = "Release Height (in)", color = NULL) +
    .report_theme()
}


# ===========================================================================
# PRIVATE HELPER:  Shared ggplot theme for report plots
# ===========================================================================
.report_theme <- function() {
  theme_minimal(base_size = 11) +
    theme(
      plot.title       = element_text(hjust = 0.5, face = "plain", size = 12),
      panel.grid.major = element_line(color = "grey88", linewidth = 0.4),
      panel.grid.minor = element_blank(),
      panel.background = element_rect(fill = "white", color = NA),
      plot.background  = element_rect(fill = "white", color = NA),
      legend.position  = "right",
      legend.title     = element_blank(),
      legend.key       = element_rect(fill = "white", color = NA),
      legend.text      = element_text(size = 9),
      axis.text        = element_text(size = 8),
      axis.title       = element_text(size = 9),
      plot.margin      = margin(5, 5, 5, 5)
    )
}

# ===========================================================================
# PRIVATE HELPER:  Summary table as a tableGrob
# ===========================================================================
.build_summary_table <- function(df) {

  # --- Per pitch-type summary ---
  pitch_summary <- df %>%
    mutate(
      Pitch_Velocity         = as.numeric(Pitch_Velocity),
      Spin_Rate              = as.numeric(Spin_Rate),
      Break_Horizontal       = as.numeric(Break_Horizontal),
      Break_Induced_Vertical = as.numeric(Break_Induced_Vertical),
      Extension              = as.numeric(Extension),
      Strike_Zone_Position   = as.numeric(Strike_Zone_Position)
    ) %>%
    group_by(Pitch_Type) %>%
    summarise(
      NP              = n(),
      `Usage %`       = round(n() / nrow(df) * 100, 1),
      `AVG Velo`      = round(mean(Pitch_Velocity, na.rm = TRUE), 1),
      `MAX Velo`      = round(max(Pitch_Velocity,  na.rm = TRUE), 1),
      `AVG Spin`      = round(mean(Spin_Rate,      na.rm = TRUE), 0),
      `AVG H Mov`     = round(mean(Break_Horizontal,       na.rm = TRUE), 1),
      `AVG V Mov`     = round(mean(Break_Induced_Vertical, na.rm = TRUE), 1),
      `AVG Ext`       = round(mean(Extension,               na.rm = TRUE), 1),
      `Zone%`         = round(
        sum(Strike_Zone_Position %in% 1:9, na.rm = TRUE) / n() * 100, 1
      ),
      .groups = "drop"
    ) %>%
    arrange(desc(NP))

  # Save original abbreviations for color mapping before renaming
  orig_abbrevs <- pitch_summary$Pitch_Type

  # --- "All Pitches" totals row (built as a one-row data frame) ---
  df_num <- df %>%
    mutate(
      Pitch_Velocity         = as.numeric(Pitch_Velocity),
      Spin_Rate              = as.numeric(Spin_Rate),
      Break_Horizontal       = as.numeric(Break_Horizontal),
      Break_Induced_Vertical = as.numeric(Break_Induced_Vertical),
      Extension              = as.numeric(Extension),
      Strike_Zone_Position   = as.numeric(Strike_Zone_Position)
    )

  totals <- data.frame(
    Pitch_Type = "All Pitches",
    NP         = nrow(df),
    `Usage %`  = NA_real_,
    `AVG Velo` = round(mean(df_num$Pitch_Velocity, na.rm = TRUE), 1),
    `MAX Velo` = round(max(df_num$Pitch_Velocity,  na.rm = TRUE), 1),
    `AVG Spin` = round(mean(df_num$Spin_Rate,      na.rm = TRUE), 0),
    `AVG H Mov`= round(mean(df_num$Break_Horizontal,       na.rm = TRUE), 1),
    `AVG V Mov`= round(mean(df_num$Break_Induced_Vertical, na.rm = TRUE), 1),
    `AVG Ext`  = round(mean(df_num$Extension,               na.rm = TRUE), 1),
    `Zone%`    = round(
      sum(df_num$Strike_Zone_Position %in% 1:9, na.rm = TRUE) / nrow(df) * 100, 1
    ),
    check.names = FALSE,
    stringsAsFactors = FALSE
  )
  colnames(totals) <- colnames(pitch_summary)

  # --- Map pitch abbreviations to display names ---
  pitch_summary <- pitch_summary %>%
    mutate(Pitch_Type = ifelse(
      Pitch_Type %in% names(PITCH_TYPE_NAMES),
      PITCH_TYPE_NAMES[Pitch_Type],
      Pitch_Type
    ))

  # Combine: totals on top
  combined <- bind_rows(totals, pitch_summary)

  # Replace NA usage with empty string for display
  combined$`Usage %`[is.na(combined$`Usage %`)] <- ""

  # Convert all columns to character for tableGrob display
  combined[] <- lapply(combined, as.character)

  # Rename for display
  colnames(combined) <- c(
    "Pitch Type", "NP", "Usage %",
    "AVG Velo\n[mph]", "MAX Velo\n[mph]",
    "AVG Spin\n[rpm]",
    "AVG H Mov\n[in]", "AVG V Mov\n[in]",
    "AVG Ext\n[ft]", "Zone%"
  )

  # --- Build color vector for Pitch Type column (row fill colors) ---
  # First row is "All Pitches" (white bg), rest get a light tint from PITCH_COLORS
  n_pitch_rows  <- nrow(pitch_summary)

  # Build a tableGrob
  tt <- ttheme_minimal(
    core = list(
      fg_params = list(fontsize = 8, hjust = 0.5, x = 0.5),
      bg_params = list(fill = "white", col = "grey80", lwd = 0.5)
    ),
    colhead = list(
      fg_params = list(fontsize = 8, fontface = "bold", hjust = 0.5, x = 0.5),
      bg_params = list(fill = "grey90", col = "grey80", lwd = 0.5)
    )
  )

  tg <- tableGrob(combined, rows = NULL, theme = tt)

  # Bold the "All Pitches" row (row 2 in the grob, row 1 is header)
  for (j in seq_len(ncol(combined))) {
    ind <- which(tg$layout$t == 2 & tg$layout$l == j & tg$layout$name == "core-fg")
    if (length(ind) > 0) {
      tg$grobs[[ind]]$gp$font <- as.integer(2)  # 2 = bold in R graphics
      tg$grobs[[ind]]$gp$fontface <- NULL
    }
  }

  # Add colored dot cells for the pitch type column
  # Row 1 = header, row 2 = totals, rows 3+ = pitch types
  for (i in seq_along(orig_abbrevs)) {
    grob_row <- i + 2  # offset for header + totals
    abbrev   <- orig_abbrevs[i]
    clr      <- if (abbrev %in% names(PITCH_COLORS)) PITCH_COLORS[abbrev] else "grey50"

    # Find the Pitch Type cell text grob
    ind <- which(tg$layout$t == grob_row & tg$layout$l == 1 & tg$layout$name == "core-fg")
    if (length(ind) > 0) {
      display_name <- tg$grobs[[ind]]$label
      # Shift text to the right to make room for the dot
      tg$grobs[[ind]] <- textGrob(
        paste0("    ", display_name),
        x = unit(0.05, "npc"), hjust = 0,
        gp = gpar(fontsize = 8, col = "black")
      )

      # Add a colored dot using pointsGrob (avoids Unicode issues on Windows)
      dot_grob <- pointsGrob(
        x = unit(0.04, "npc"), y = unit(0.5, "npc"),
        pch = 19, size = unit(5, "pt"),
        gp = gpar(col = clr)
      )
      tg <- gtable::gtable_add_grob(
        tg, dot_grob,
        t = grob_row, l = 1, name = paste0("dot-", i)
      )
    }
  }

  tg
}
