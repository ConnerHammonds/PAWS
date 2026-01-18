#' Application Logger
#' 
#' Centralized logging system for the Baseball Analytics Dashboard.
#' Uses the logger package with environment-specific configuration.
#' 
#' @import logger
#' @export

library(logger)

#' Initialize Application Logger
#' 
#' Sets up logging based on config.yml settings for the current environment.
#' Configures log levels, output destinations, and formatting.
#' 
#' @param config Configuration object from config package
#' @return NULL (configures logger as a side effect)
#' @examples
#' config <- config::get()
#' init_logger(config)
init_logger <- function(config = NULL) {
  if (is.null(config)) {
    config <- config::get()
  }
  
  # Set log level
  log_level <- config$logging$level
  logger::log_threshold(log_level)
  
  # Configure log layout with timestamps
  logger::log_layout(logger::layout_glue_colors)
  
  # Add file appender if specified
  if (!is.null(config$logging$file)) {
    log_dir <- dirname(config$logging$file)
    if (!dir.exists(log_dir)) {
      dir.create(log_dir, recursive = TRUE)
    }
    
    logger::log_appender(
      logger::appender_tee(config$logging$file),
      index = 1
    )
  }
  
  # Console logging based on config
  if (!config$logging$console) {
    logger::log_appender(logger::appender_file(config$logging$file))
  }
  
  logger::log_info("Logger initialized - Level: {log_level}")
  invisible(NULL)
}

#' Log User Action
#' 
#' Logs user actions with context for audit trails.
#' 
#' @param user_id User identifier
#' @param action Action performed
#' @param details Additional details (optional)
#' @examples
#' log_user_action("user123", "data_upload", "Uploaded pitching_data.csv")
log_user_action <- function(user_id, action, details = "") {
  logger::log_info("USER_ACTION | User: {user_id} | Action: {action} | {details}")
}

#' Log Database Operation
#' 
#' Logs database queries and operations for monitoring and debugging.
#' 
#' @param operation Type of operation (SELECT, INSERT, UPDATE, etc.)
#' @param table_name Table affected
#' @param rows_affected Number of rows (optional)
#' @param duration_ms Duration in milliseconds (optional)
log_db_operation <- function(operation, table_name, rows_affected = NULL, duration_ms = NULL) {
  msg <- "DB_OPERATION | {operation} | Table: {table_name}"
  if (!is.null(rows_affected)) msg <- paste0(msg, " | Rows: {rows_affected}")
  if (!is.null(duration_ms)) msg <- paste0(msg, " | Duration: {duration_ms}ms")
  logger::log_debug(msg)
}

#' Log Error with Context
#' 
#' Logs errors with full context for debugging.
#' 
#' @param error_msg Error message
#' @param context Additional context (function name, user, etc.)
#' @param error_obj Error object from tryCatch (optional)
log_error_context <- function(error_msg, context = "", error_obj = NULL) {
  full_msg <- "ERROR | {error_msg}"
  if (context != "") full_msg <- paste0(full_msg, " | Context: {context}")
  if (!is.null(error_obj)) full_msg <- paste0(full_msg, " | Details: {error_obj$message}")
  
  logger::log_error(full_msg)
}

#' Log Performance Metric
#' 
#' Logs performance metrics for monitoring app responsiveness.
#' 
#' @param metric_name Name of the metric
#' @param value Metric value
#' @param unit Unit of measurement (optional)
log_performance <- function(metric_name, value, unit = "") {
  logger::log_debug("PERFORMANCE | {metric_name}: {value}{unit}")
}
