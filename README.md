# Baseball Analytics Dashboard - Production-Grade Data Analytics Platform

A professional-grade web application for baseball analytics, designed for college and professional teams. Built with R Shiny and PostgreSQL, featuring advanced visualizations, secure authentication, and white-label branding capabilities.

## 🎯 Features

- **Multi-Tenant Architecture**: Support for multiple teams with isolated data
- **Advanced Analytics**: Pitch heat maps, spray charts, velocity trends, and spin rate analysis
- **Secure Authentication**: Role-based access control (Admin/Coach/Player)
- **White-Label Branding**: Dynamic theming system for team-specific branding
- **Data Persistence**: PostgreSQL database for reliable data storage
- **Professional Deployment**: Docker containerization with CI/CD pipeline
- **Comprehensive Logging**: Production-grade logging and monitoring
- **Testing Suite**: Automated testing with testthat and shinytest2

## 📁 Project Structure

```
baseball_analytics_dashboard/
├── .github/
│   └── workflows/
│       └── deploy.yml          # CI/CD pipeline configuration
├── db/
│   └── init.sql                # Database schema and initialization
├── R/                          # Shiny modules and utilities
│   ├── mod_pitching.R         # Pitching analytics module
│   ├── mod_hitting.R          # Hitting analytics module
│   ├── mod_admin.R            # Admin portal module
│   ├── utils_db.R             # Database functions (with roxygen2 docs)
│   ├── utils_theme.R          # Theme utilities
│   └── utils_logging.R        # Logging system
├── tests/
│   └── testthat/              # Automated tests
│       ├── test-database.R
│       ├── test-theme.R
│       └── test-modules.R
├── logs/                       # Application logs
├── data/                       # Local data storage
├── www/                        # Static assets (CSS, images, logos)
├── global.R                    # Global setup with config and logging
├── ui.R                        # User interface
├── server.R                    # Server logic
├── config.yml                  # Environment-specific configuration
├── .env.example                # Environment variables template
├── .gitignore                  # Git ignore rules
├── Dockerfile                  # Docker container definition
├── docker-compose.yml          # Multi-container orchestration
├── renv.lock                   # Package version lockfile
└── install_packages.R          # Package installation script
```

## 🚀 Quick Start

### Prerequisites

- R 4.5.2 or higher
- PostgreSQL 16+ (or use Docker)
- Git

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd baseball_analytics_dashboard
   ```

2. **Set up environment variables**
   ```bash
   cp .env.example .env
   # Edit .env with your configuration
   ```

3. **Install R packages**
   ```r
   # Using renv (recommended)
   renv::restore()
   
   # Or using install script
   source("install_packages.R")
   ```

4. **Start with Docker (easiest)**
   ```bash
   docker-compose up -d
   ```
   
   Access the app at: `http://localhost:3838`
   
   Access pgAdmin at: `http://localhost:5050`

5. **Or run locally**
   ```r
   # Start PostgreSQL separately, then:
   shiny::runApp()
   ```

## 🔧 Configuration

### Environment Variables

Copy [.env.example](.env.example) to `.env` and configure:

```env
# Database
DB_HOST=localhost
DB_PORT=5432
DB_NAME=baseball_analytics
DB_USER=your_username
DB_PASSWORD=your_password

# Application
R_CONFIG_ACTIVE=development  # or staging, production
```

### Configuration Profiles

Edit [config.yml](config.yml) for environment-specific settings:

- **Development**: Debug mode, verbose logging
- **Staging**: Testing environment
- **Production**: Optimized for performance and security

## 📊 Database Schema

Comprehensive PostgreSQL schema includes:

- `teams` - Multi-tenant team configuration
- `users` - Authentication and authorization
- `players` - Player roster management
- `pitch_data` - Pitch-level metrics (velocity, spin rate, location)
- `hit_data` - Hitting metrics (exit velocity, launch angle, spray charts)
- `audit_log` - Activity tracking

See [db/init.sql](db/init.sql) for complete schema.

## 🧪 Testing

```r
# Run all tests
testthat::test_dir("tests")

# Run specific test file
testthat::test_file("tests/testthat/test-database.R")
```

## 📦 Package Management

This project uses `renv` for reproducible package management:

```r
# Check status
renv::status()

# Update lockfile after adding packages
renv::snapshot()

# Restore packages from lockfile
renv::restore()
```

## 🐳 Docker Deployment

### Build and Run

```bash
# Build image
docker build -t baseball-analytics:latest .

# Run with docker-compose
docker-compose up -d

# View logs
docker-compose logs -f app

# Stop services
docker-compose down
```

### Production Deployment

1. Set `R_CONFIG_ACTIVE=production` in your environment
2. Configure production database credentials
3. Set up SSL/TLS certificates
4. Configure reverse proxy (nginx/traefik)
5. Set up monitoring and backups

## 🔐 Security

- **Environment Variables**: Sensitive data in `.env` (never commit)
- **Password Hashing**: bcrypt for user passwords
- **SQL Injection Protection**: Parameterized queries with DBI
- **Session Management**: Secure session handling with shinymanager
- **Audit Logging**: All user actions tracked
- **Role-Based Access**: Admin, Coach, and Player permissions

## 📈 Monitoring & Logging

Structured logging with the `logger` package:

```r
# Log levels: DEBUG, INFO, WARN, ERROR
log_info("User logged in: {username}")
log_user_action(user_id, "data_upload", "Uploaded 500 rows")
log_error_context("Database query failed", "get_pitch_data")
```

Logs are stored in `logs/` directory with rotation.

## 🎨 White-Label Branding

Configure team-specific branding in [config.yml](config.yml):

```yaml
teams:
  your_team:
    team_name: "Your Team Name"
    primary_color: "#003366"
    secondary_color: "#FFFFFF"
    logo: "www/logos/your_logo.png"
```

## 🔄 CI/CD Pipeline

GitHub Actions workflow ([.github/workflows/deploy.yml](.github/workflows/deploy.yml)):

1. **Test**: Run automated tests on push
2. **Lint**: Code quality checks
3. **Build**: Create Docker image
4. **Deploy**: Auto-deploy to staging/production

## 📝 Development Phases

- [x] **Phase 1**: Foundation & Package Setup
- [x] **Phase 2**: Modular Architecture
- [x] **Phase 3**: Production Infrastructure (renv, config, logging, tests)
- [x] **Phase 4**: Database Schema & Docker Deployment
- [ ] **Phase 5**: Authentication with shinymanager
- [ ] **Phase 6**: Data Upload & Processing
- [ ] **Phase 7**: Visualization Modules
- [ ] **Phase 8**: User Acceptance Testing
- [ ] **Phase 9**: Production Deployment

## 🤝 Contributing

1. Create feature branch: `git checkout -b feature/your-feature`
2. Write tests for new functionality
3. Update documentation
4. Submit pull request

## 📄 License

Commercial license - suitable for selling to teams. Contact for licensing details.

## 📧 Support

For support, feature requests, or licensing inquiries, contact the development team.

## 🏗️ Tech Stack

- **Language**: R 4.5.2
- **Framework**: Shiny (modular architecture)
- **Database**: PostgreSQL 16
- **UI**: bslib (Bootstrap 5) + thematic
- **Visualization**: ggplot2, plotly
- **Authentication**: shinymanager
- **Testing**: testthat, shinytest2
- **Logging**: logger
- **Config**: config package
- **Package Management**: renv
- **Containerization**: Docker, Docker Compose
- **CI/CD**: GitHub Actions

---