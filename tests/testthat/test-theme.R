# Tests for Theme Utility Functions

test_that("Theme creation returns valid bslib theme", {
  theme <- create_app_theme("#8B0015", "#FFFFFF", "#222222")
  
  expect_s3_class(theme, "bs_theme")
})

test_that("Get team theme returns correct structure", {
  theme_config <- list(
    primary = "#8B0015",
    secondary = "#FFFFFF",
    accent = "#222222",
    team_name = "Test Team"
  )
  
  expect_type(theme_config, "list")
  expect_true("primary" %in% names(theme_config))
  expect_true("team_name" %in% names(theme_config))
})

test_that("Color values are valid hex codes", {
  colors <- c("#8B0015", "#FFFFFF", "#222222")
  
  for (color in colors) {
    expect_match(color, "^#[0-9A-Fa-f]{6}$")
  }
})
