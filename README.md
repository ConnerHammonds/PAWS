# Baseball Analytics Dashboard - Production-Grade Data Analytics Platform

A professional-grade web application for baseball analytics, designed for college and professional teams. Built with R Shiny and PostgreSQL, featuring advanced visualizations, secure authentication, and white-label branding capabilities.

## 🎯 Features

- **Multi-Tenant Architecture**: Support for multiple teams with isolated data
- **Advanced Analytics**: Pitch heat maps, spray charts, velocity trends, and spin rate analysis
- **Secure Authentication**: Role-based access control (Admin/Coach/Player) [Planned]
- **White-Label Branding**: Dynamic theming system for team-specific branding
- **Data Persistence**: PostgreSQL database schema ready for implementation
- **Reproducible Environments**: renv package management for consistent deployments
- **Environment Configuration**: config package for development/staging/production settings

## 📁 Project Structure

```
baseball_analytics_dashboard/
├── db/
│   └── init.sql                # Database schema (PostgreSQL)
├── R/                          # Shiny modules and utilities
│   ├── mod_pitching.R         # Pitching analytics module
│   ├── mod_hitting.R          # Hitting analytics module
│   ├── mod_admin.R            # Admin portal module
│   ├── utils_db.R             # Database functions (placeholder)
│   └── utils_theme.R          # Theme utilities
├── data/                       # Local data storage
├── www/                        # Static assets (CSS, images, logos)
├── renv/                       # renv package library
│   ├── activate.R             # renv activation script
│   ├── settings.json          # renv configuration
│   └── library/               # Project-specific packages
├── global.R                    # Global setup and configuration
├── ui.R                        # User interface
├── server.R                    # Server logic
├── run_dev.ps1                 # Development server launcher (PowerShell)
├── run_dev.R                   # Development server launcher (R)
├── config.yml                  # Environment-specific configuration
├── .env.example                # Environment variables template
├── .Rprofile                   # renv activation on project load
├── .gitignore                  # Git ignore rules
└── renv.lock                   # Package version lockfile
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

2. **Install R packages**
   
   When you open R in this directory, renv automatically activates and prompts you to restore packages:
   ```r
   renv::restore()
   ```
   
   This installs all dependencies from renv.lock (exact versions for reproducibility).

3. **Run the development server**
   
   **Windows (PowerShell):**
   ```powershell
   .\run_dev.ps1
   ```
   
   **R Console:**
   ```r
   source("run_dev.R")
   ```
   
   **Or directly:**
   ```r
   shiny::runApp(port = 3838)
   ```
   
   Access the app at: `http://localhost:3838`

4. **Optional: Set up PostgreSQL database** (for future phases)
   ```bash
   # Create database
   createdb baseball_analytics
   
   # Initialize schema
   psql -d baseball_analytics -f db/init.sql
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

##  Security

- **Environment Variables**: Sensitive data in `.env` (never commit)
- **Password Hashing**: bcrypt for user passwords
- **SQL Injection Protection**: Parameterized queries with DBI
- **Session Management**: Secure session handling with shinymanager
- **Audit Logging**: All user actions tracked
- **Role-Based Access**: Admin, Coach, and Player permissions

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

##  Development Phases

- [x] **Phase 1**: Foundation & Package Setup
- [x] **Phase 2**: Modular Architecture (basic structure)
- [x] **Phase 3**: Environment Management (renv, config)
- [x] **Phase 4**: Database Schema Design
- [ ] **Phase 5**: Database Integration
- [ ] **Phase 6**: Authentication
- [ ] **Phase 7**: Data Upload & Processing
- [ ] **Phase 8**: Visualization Modules
- [ ] **Phase 9**: Testing & Deployment

**Current Status**: Early development - core infrastructure in place, ready for feature implementation

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
- **Database**: PostgreSQL 16 (schema ready, integration pending)
- **UI**: bslib (Bootstrap 5)
- **Data Manipulation**: dplyr
- **Visualization**: ggplot2
- **Configuration**: config package (environment-specific settings)
- **Package Management**: renv (reproducible environments)

**Planned Additions:**
- plotly (interactive visualizations)
- shinymanager (authentication)
- RPostgres (database connectivity)

---