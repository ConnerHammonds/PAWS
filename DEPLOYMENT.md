# Deployment Guide - Baseball Analytics Dashboard

This guide covers deploying the Baseball Analytics Dashboard to production environments suitable for selling to college and professional teams.

## Table of Contents

1. [Deployment Options](#deployment-options)
2. [Local Development](#local-development)
3. [Docker Deployment](#docker-deployment)
4. [Cloud Deployment](#cloud-deployment)
5. [Security Checklist](#security-checklist)
6. [Monitoring & Maintenance](#monitoring--maintenance)

---

## Deployment Options

### Option 1: Local Development (Current)
**Best for**: Early development, testing features
- Direct R execution with renv
- Fast iteration
- Easy debugging

### Option 2: Cloud Platform (ShinyApps.io, Posit Connect) [Future]
**Best for**: Managed hosting, automatic scaling
- No server management required
- Built-in SSL/TLS
- Easy deployment from RStudio

### Option 3: VPS/Dedicated Server [Future]
**Best for**: Full control, custom requirements
- Maximum customization
- Direct server access
- Requires server administration knowledge

### Option 4: Containerization (Docker/Kubernetes) [Stretch Goal]
**Best for**: Enterprise deployments, high availability
- Isolated environments
- Easy scaling
- Production-grade deployment

---

## Local Development

### Setup Steps

1. **Install Prerequisites**
   - R 4.5.2 or higher
   - Git
   - RStudio (optional but recommended) or VS Code with R extension

2. **Clone and Configure**
   ```bash
   git clone <repository>
   cd baseball_analytics_dashboard
   ```

3. **Install R Packages**
   
   renv automatically activates when you open R in this directory.
   ```r
   # Restore packages from lockfile
   renv::restore()
   ```

4. **Run the Development Server**
   
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
   Sys.setenv(R_CONFIG_ACTIVE = "development")
   shiny::runApp(port = 3838)
   ```
   
   Access the app at: `http://localhost:3838`

5. **Database Setup** (optional - for future phases)
   ```bash
   # Install PostgreSQL locally
   # Create database
   createdb baseball_analytics
   
   # Run initialization script
   psql -d baseball_analytics -f db/init.sql
   ```

### Development Workflow

1. **Make changes** to R files (modules, UI, server)
2. **Reload app** - Shiny auto-reloads on file save
3. **Test manually** in browser
4. **Add new packages** if needed:
   ```r
   install.packages("package_name")
   renv::snapshot()  # Update lockfile
   ```
5. **Commit changes** including updated renv.lock

---

## Cloud Deployment (Future)

### Posit Connect / ShinyApps.io

**Note**: Database integration required before cloud deployment

1. **Install rsconnect**
   ```r
   install.packages("rsconnect")
   ```

2. **Configure Account**
   ```r
   rsconnect::setAccountInfo(
     name = "your-account",
     token = "your-token",
     secret = "your-secret"
   )
   ```

3. **Deploy**
   ```r
   rsconnect::deployApp(
     appDir = ".",
     appName = "baseball-analytics",
     forceUpdate = TRUE
   )
   ```

### AWS Deployment (Advanced)

**Future option when ready for production:**

1. **Set up RDS PostgreSQL**
   - Create RDS PostgreSQL instance
   - Configure security groups
   - Note connection details for config.yml

2. **EC2 with Shiny Server**
   - Launch Ubuntu EC2 instance
   - Install R and Shiny Server
   - Clone repository and use renv::restore()
   - Configure reverse proxy (nginx) with SSL

3. **Environment Configuration**
   - Set R_CONFIG_ACTIVE=production
   - Configure database credentials in environment variables
   - Set up CloudWatch for monitoring

---

## Security Checklist

### Development (Current)

- [x] renv for reproducible package management
- [x] config.yml for environment-specific settings
- [x] .gitignore properly configured
- [ ] Database schema ready (not yet integrated)
- [ ] Authentication system (planned)

### Before Production Deployment (Future)

- [ ] Implement authentication (shinymanager)
- [ ] Set up PostgreSQL database
- [ ] Change all default passwords
- [ ] Set `R_CONFIG_ACTIVE=production`
- [ ] Enable HTTPS/SSL
- [ ] Configure firewall rules
- [ ] Set up database backups
- [ ] Review user permissions
- [ ] Set up monitoring

### Environment Variables (When Implemented)

**Never commit these to version control:**

```bash
# Critical secrets
DB_USER=app_user
DB_PASSWORD=<strong-password>
DB_HOST=<database-host>
```

### Database Security

```sql
-- Create dedicated app user (not postgres superuser)
CREATE USER app_user WITH PASSWORD 'strong_password';

-- Grant minimal required permissions
GRANT CONNECT ON DATABASE baseball_analytics TO app_user;
GRANT SELECT, INSERT, UPDATE ON ALL TABLES IN SCHEMA public TO app_user;

-- Enable SSL connections
ALTER SYSTEM SET ssl = on;
```

### Application Security

```yaml
# config.yml - production settings
production:
  app:
    debug_mode: false  # Never true in production
    session_timeout: 1800  # 30 minutes
  
  logging:
    level: "WARN"  # Reduce verbosity
    console: false  # Log to file only
```

---

## Monitoring & Maintenance

### Current Development

**Manual Testing:**
- Run app locally with `.\run_dev.ps1`
- View errors in R console
- Check browser console for JavaScript errors

**Package Management:**
```r
# Check for package changes
renv::status()

# Update lockfile after installing new packages
renv::snapshot()

# Sync with lockfile after pulling changes
renv::restore()
```

### Future Production Monitoring

**Health Checks:**
```bash
# Application health
curl http://localhost:3838/

# Database health (when implemented)
psql -h localhost -U app_user -d baseball_analytics -c "SELECT 1;"
```

**Backup Strategy** (when database is integrated):
- Automated daily PostgreSQL backups
- Data directory backups
- Version control for code changes

---

## Troubleshooting

### Common Development Issues

**1. Packages Won't Install**
```r
# Clear renv cache and retry
renv::clean()
renv::restore()

# Check R version matches lockfile
R.version.string  # Should be R 4.5.2
```

**2. App Won't Start**
```r
# Check for syntax errors in R console
source("global.R")
source("ui.R")
source("server.R")

# Verify all modules load
source("R/mod_pitching.R")
source("R/mod_hitting.R")
source("R/mod_admin.R")
```

**3. Port Already in Use**
```powershell
# Windows: Find and kill process using port 3838
netstat -ano | findstr :3838
taskkill /PID <process-id> /F

# Or use a different port
shiny::runApp(port = 8080)
```

**4. renv Issues**
```r
# Restart R session and try again
.rs.restartR()  # In RStudio

# Or manually activate
source("renv/activate.R")
```

---

## Support & Resources

- **Documentation**: See README.md
- **Configuration**: config.yml
- **Database Schema**: db/init.sql
- **Package Management**: Use renv commands (status, snapshot, restore)

---

**Last Updated**: January 2026
**Current Status**: Early development - local development workflow established
