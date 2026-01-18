-- Baseball Analytics Database Schema
-- PostgreSQL initialization script

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Teams table
CREATE TABLE IF NOT EXISTS teams (
    team_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    team_name VARCHAR(100) NOT NULL UNIQUE,
    primary_color VARCHAR(7) DEFAULT '#003366',
    secondary_color VARCHAR(7) DEFAULT '#FFFFFF',
    logo_url TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Users table (for authentication)
CREATE TABLE IF NOT EXISTS users (
    user_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    username VARCHAR(50) NOT NULL UNIQUE,
    password_hash TEXT NOT NULL,
    email VARCHAR(100),
    role VARCHAR(20) NOT NULL CHECK (role IN ('admin', 'coach', 'player')),
    team_id UUID REFERENCES teams(team_id) ON DELETE CASCADE,
    active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_login TIMESTAMP
);

-- Players table
CREATE TABLE IF NOT EXISTS players (
    player_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    team_id UUID REFERENCES teams(team_id) ON DELETE CASCADE,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    jersey_number INTEGER,
    position VARCHAR(20),
    bats VARCHAR(1) CHECK (bats IN ('L', 'R', 'S')),  -- Left, Right, Switch
    throws VARCHAR(1) CHECK (throws IN ('L', 'R')),
    active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(team_id, jersey_number)
);

-- Pitch data table
CREATE TABLE IF NOT EXISTS pitch_data (
    pitch_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    player_id UUID REFERENCES players(player_id) ON DELETE CASCADE,
    team_id UUID REFERENCES teams(team_id) ON DELETE CASCADE,
    pitch_date DATE NOT NULL,
    pitch_time TIME,
    pitch_number INTEGER,
    pitch_type VARCHAR(20),  -- Fastball, Curveball, Slider, Changeup, etc.
    velocity DECIMAL(5,2),   -- mph
    spin_rate INTEGER,       -- rpm
    spin_axis INTEGER,       -- degrees
    release_height DECIMAL(5,2),  -- feet
    release_side DECIMAL(5,2),    -- feet
    extension DECIMAL(5,2),       -- feet
    location_x DECIMAL(5,2),      -- horizontal location (feet)
    location_y DECIMAL(5,2),      -- vertical location (feet)
    induced_vert_break DECIMAL(5,2),  -- inches
    horz_break DECIMAL(5,2),          -- inches
    plate_side DECIMAL(5,2),      -- at plate (feet)
    plate_height DECIMAL(5,2),    -- at plate (feet)
    result VARCHAR(50),  -- Ball, Strike, In Play, etc.
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Hit data table
CREATE TABLE IF NOT EXISTS hit_data (
    hit_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    player_id UUID REFERENCES players(player_id) ON DELETE CASCADE,
    team_id UUID REFERENCES teams(team_id) ON DELETE CASCADE,
    hit_date DATE NOT NULL,
    hit_time TIME,
    exit_velocity DECIMAL(5,2),  -- mph
    launch_angle DECIMAL(5,2),   -- degrees
    direction DECIMAL(5,2),      -- degrees (spray angle)
    distance DECIMAL(5,1),       -- feet
    hang_time DECIMAL(4,2),      -- seconds
    hit_type VARCHAR(20),        -- Ground Ball, Line Drive, Fly Ball, Pop Up
    hit_location_x DECIMAL(6,2), -- field coordinates
    hit_location_y DECIMAL(6,2), -- field coordinates
    result VARCHAR(50),          -- Single, Double, Triple, HR, Out, etc.
    pitch_type_faced VARCHAR(20),
    pitch_velocity_faced DECIMAL(5,2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Audit log table
CREATE TABLE IF NOT EXISTS audit_log (
    log_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(user_id),
    action VARCHAR(100) NOT NULL,
    table_name VARCHAR(50),
    record_id UUID,
    details JSONB,
    ip_address INET,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for performance
CREATE INDEX idx_pitch_data_player ON pitch_data(player_id);
CREATE INDEX idx_pitch_data_date ON pitch_data(pitch_date);
CREATE INDEX idx_pitch_data_team ON pitch_data(team_id);
CREATE INDEX idx_hit_data_player ON hit_data(player_id);
CREATE INDEX idx_hit_data_date ON hit_data(hit_date);
CREATE INDEX idx_hit_data_team ON hit_data(team_id);
CREATE INDEX idx_users_team ON users(team_id);
CREATE INDEX idx_players_team ON players(team_id);
CREATE INDEX idx_audit_log_user ON audit_log(user_id);
CREATE INDEX idx_audit_log_created ON audit_log(created_at);

-- Insert default SBU team
INSERT INTO teams (team_name, primary_color, secondary_color) 
VALUES ('SBU Bearcats', '#8B0015', '#FFFFFF')
ON CONFLICT (team_name) DO NOTHING;

-- Insert demo admin user (password: changeme123 - CHANGE IN PRODUCTION!)
-- Password hash generated with bcrypt
INSERT INTO users (username, password_hash, email, role, team_id)
SELECT 'admin', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 
       'admin@sbu.edu', 'admin', team_id
FROM teams WHERE team_name = 'SBU Bearcats'
ON CONFLICT (username) DO NOTHING;

-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Trigger for teams table
CREATE TRIGGER update_teams_updated_at BEFORE UPDATE ON teams
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Grant appropriate permissions (adjust as needed)
-- Example: GRANT SELECT, INSERT, UPDATE ON ALL TABLES IN SCHEMA public TO app_user;
