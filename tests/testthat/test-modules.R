# Tests for Shiny Modules

library(shinytest2)

# Note: Full module testing requires shinytest2
# These are basic structural tests

test_that("Pitching module UI returns tagList", {
  ui <- mod_pitching_ui("test")
  expect_s3_class(ui, "shiny.tag.list")
})

test_that("Hitting module UI returns tagList", {
  ui <- mod_hitting_ui("test")
  expect_s3_class(ui, "shiny.tag.list")
})

test_that("Admin module UI returns tagList", {
  ui <- mod_admin_ui("test")
  expect_s3_class(ui, "shiny.tag.list")
})

# Integration tests with shinytest2 (uncomment when ready)
# test_that("App launches successfully", {
#   app <- AppDriver$new(app_dir = "../../")
#   expect_true(app$is_alive())
#   app$stop()
# })
