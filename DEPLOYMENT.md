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

### Option 1: Docker (Recommended)
**Best for**: Quick deployment, testing, and containerized environments
- Includes PostgreSQL, app server, and optional pgAdmin
- Isolated environment
- Easy scaling

### Option 2: Cloud Platform (ShinyApps.io, Posit Connect)
**Best for**: Managed hosting, automatic scaling
- No server management required
- Built-in SSL/TLS
- Limited customization

### Option 3: VPS/Dedicated Server
**Best for**: Full control, custom requirements
- Maximum customization
- Direct server access
- Requires server administration knowledge

### Option 4: Kubernetes
**Best for**: Enterprise deployments, high availability
- Auto-scaling
- Load balancing
- Complex setup

---

## Local Development

### Setup Steps

1. **Install Prerequisites**
   ```bash
   # Install R 4.5.2
   # Install PostgreSQL 16
   # Install Git
   ```

2. **Clone and Configure**
   ```bash
   git clone <repository>
   cd baseball_analytics_dashboard
   cp .env.example .env
   # Edit .env with your settings
   ```

3. **Set up Database**
   ```bash
   # Create database
   createdb baseball_analytics
   
   # Run initialization script
   psql -d baseball_analytics -f db/init.sql
   ```

4. **Install R Packages**
   ```r
   renv::restore()
   ```

5. **Run Application**
   ```r
   # Set environment
   Sys.setenv(R_CONFIG_ACTIVE = "development")
   
   # Run app
   shiny::runApp()
   ```

---

## Docker Deployment

### Quick Start (Development)

```bash
# Start all services
docker-compose up -d

# View logs
docker-compose logs -f

# Stop services
docker-compose down
```

### Production Deployment

1. **Create Production Environment File**
   ```bash
   cp .env.example .env.production
   # Edit with production credentials
   ```

2. **Update docker-compose for Production**
   ```yaml
   # docker-compose.prod.yml
   services:
     app:
       environment:
         R_CONFIG_ACTIVE: production
       restart: always
   ```

3. **Deploy**
   ```bash
   docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d
   ```

4. **Set up Reverse Proxy (nginx)**
   ```nginx
   server {
       listen 80;
       server_name analytics.yourteam.com;
       
       location / {
           proxy_pass http://localhost:3838;
           proxy_http_version 1.1;
           proxy_set_header Upgrade $http_upgrade;
           proxy_set_header Connection "upgrade";
           proxy_set_header Host $host;
           proxy_cache_bypass $http_upgrade;
       }
   }
   ```

5. **Enable SSL with Let's Encrypt**
   ```bash
   sudo certbot --nginx -d analytics.yourteam.com
   ```

---

## Cloud Deployment

### AWS Deployment (Recommended for Enterprise)

#### Option A: ECS (Elastic Container Service)

1. **Push Image to ECR**
   ```bash
   # Authenticate
   aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin <account-id>.dkr.ecr.us-east-1.amazonaws.com
   
   # Build and tag
   docker build -t baseball-analytics .
   docker tag baseball-analytics:latest <account-id>.dkr.ecr.us-east-1.amazonaws.com/baseball-analytics:latest
   
   # Push
   docker push <account-id>.dkr.ecr.us-east-1.amazonaws.com/baseball-analytics:latest
   ```

2. **Set up RDS PostgreSQL**
   - Create RDS PostgreSQL instance
   - Configure security groups
   - Note connection details

3. **Create ECS Task Definition**
   ```json
   {
     "family": "baseball-analytics",
     "containerDefinitions": [{
       "name": "app",
       "image": "<ecr-image-url>",
       "portMappings": [{"containerPort": 3838}],
       "environment": [
         {"name": "R_CONFIG_ACTIVE", "value": "production"},
         {"name": "DB_HOST", "value": "<rds-endpoint>"}
       ],
       "secrets": [
         {"name": "DB_PASSWORD", "valueFrom": "<secrets-manager-arn>"}
       ]
     }]
   }
   ```

4. **Deploy with Load Balancer**
   - Create Application Load Balancer
   - Configure target group for port 3838
   - Set up health checks
   - Enable auto-scaling

#### Option B: EC2 Instance

```bash
# Connect to EC2
ssh -i your-key.pem ubuntu@<instance-ip>

# Install Docker
sudo apt update
sudo apt install docker.io docker-compose

# Clone repository
git clone <repository>
cd baseball_analytics_dashboard

# Configure environment
cp .env.example .env
# Edit .env

# Deploy
docker-compose up -d
```

### Posit Connect / ShinyApps.io

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

### Google Cloud Platform (GCP)

1. **Cloud Run Deployment**
   ```bash
   # Build and push to GCR
   gcloud builds submit --tag gcr.io/PROJECT_ID/baseball-analytics
   
   # Deploy to Cloud Run
   gcloud run deploy baseball-analytics \
     --image gcr.io/PROJECT_ID/baseball-analytics \
     --platform managed \
     --region us-central1 \
     --allow-unauthenticated
   ```

2. **Cloud SQL for PostgreSQL**
   - Create Cloud SQL instance
   - Configure Cloud SQL Proxy
   - Update connection settings

---

## Security Checklist

### Before Production Deployment

- [ ] Change all default passwords
- [ ] Generate strong `APP_SECRET_KEY`
- [ ] Set `R_CONFIG_ACTIVE=production`
- [ ] Enable HTTPS/SSL
- [ ] Configure firewall rules
- [ ] Set up database backups
- [ ] Enable audit logging
- [ ] Review user permissions
- [ ] Scan for vulnerabilities
- [ ] Set up monitoring alerts

### Environment Variables

**Never commit these to version control:**

```bash
# Critical secrets
DB_PASSWORD=<strong-password>
APP_SECRET_KEY=<random-string>
ADMIN_PASSWORD=<secure-password>
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

### Health Checks

```bash
# Application health
curl http://localhost:3838/

# Database health
psql -h localhost -U app_user -d baseball_analytics -c "SELECT 1;"
```

### Log Monitoring

```bash
# Docker logs
docker-compose logs -f app

# Application logs
tail -f logs/production.log

# Database logs
docker-compose logs -f postgres
```

### Backup Strategy

```bash
# Automated daily backup script
#!/bin/bash
DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="/backups/baseball_analytics"

# Backup database
docker exec baseball_analytics_db pg_dump -U postgres baseball_analytics | gzip > "$BACKUP_DIR/db_$DATE.sql.gz"

# Backup uploaded files
tar -czf "$BACKUP_DIR/data_$DATE.tar.gz" data/

# Keep last 30 days
find $BACKUP_DIR -name "*.gz" -mtime +30 -delete
```

### Performance Monitoring

```r
# Add to global.R for performance tracking
if (app_config$monitoring$enabled) {
  # Track response times
  observe({
    start_time <- Sys.time()
    # ... app logic ...
    duration <- as.numeric(Sys.time() - start_time)
    log_performance("page_load", duration, "seconds")
  })
}
```

### Scaling Considerations

**Vertical Scaling** (Increase resources):
- Upgrade server CPU/RAM
- Increase PostgreSQL connection pool size
- Optimize database queries

**Horizontal Scaling** (Multiple instances):
- Use load balancer
- Shared PostgreSQL database
- Redis for session storage
- CDN for static assets

---

## Troubleshooting

### Common Issues

**1. Database Connection Failed**
```bash
# Check PostgreSQL is running
docker-compose ps

# Test connection
docker exec -it baseball_analytics_db psql -U postgres -d baseball_analytics

# Check logs
docker-compose logs postgres
```

**2. App Won't Start**
```bash
# Check R packages
docker exec -it baseball_analytics_app R -e "renv::status()"

# View detailed logs
docker-compose logs --tail=100 app
```

**3. Permission Denied**
```bash
# Fix file permissions
chmod -R 755 baseball_analytics_dashboard/
chown -R $USER:$USER baseball_analytics_dashboard/
```

**4. Out of Memory**
```bash
# Increase Docker memory limit
# Docker Desktop: Settings > Resources > Memory

# Or in docker-compose.yml
services:
  app:
    mem_limit: 4g
```

---

## Support & Resources

- **Documentation**: See README.md
- **Issues**: Check logs in `logs/` directory
- **Database Schema**: `db/init.sql`
- **Configuration**: `config.yml`

For commercial support and licensing, contact the development team.

---

**Last Updated**: January 2026
