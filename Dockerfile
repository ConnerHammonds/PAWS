# Dockerfile for Baseball Analytics Dashboard
# Multi-stage build for optimized production deployment

FROM rocker/shiny:4.5.2 AS base

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libpq-dev \
    libssl-dev \
    libcurl4-openssl-dev \
    libxml2-dev \
    git \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /srv/shiny-server/baseball-analytics

# Copy renv files first for better caching
COPY renv.lock renv.lock
COPY .Rprofile .Rprofile
COPY renv/activate.R renv/activate.R
COPY renv/settings.json renv/settings.json

# Install renv and restore packages
RUN R -e "install.packages('renv', repos='https://cloud.r-project.org')"
RUN R -e "renv::restore()"

# Copy application files
COPY global.R global.R
COPY ui.R ui.R
COPY server.R server.R
COPY config.yml config.yml
COPY R/ R/
COPY www/ www/

# Create logs directory
RUN mkdir -p logs

# Set environment variables
ENV R_CONFIG_ACTIVE=production
ENV SHINY_PORT=3838

# Expose port
EXPOSE 3838

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=60s \
  CMD curl -f http://localhost:3838/ || exit 1

# Run the application
CMD ["R", "-e", "shiny::runApp(port=3838, host='0.0.0.0')"]
