# Baseball Analytics Dashboard - Test Suite
# Run with: testthat::test_dir("tests") from project root

library(testthat)
library(shiny)

# Source application files from project root
# Tests run from tests/testthat/, so go up two directories
if (file.exists("../../global.R")) {
  source("../../global.R")
} else if (file.exists("global.R")) {
  source("global.R")
}
