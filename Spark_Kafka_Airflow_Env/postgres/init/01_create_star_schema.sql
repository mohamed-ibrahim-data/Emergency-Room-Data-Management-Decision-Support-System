-- =====================================================================
-- Star Schema for Emergency Room Data Warehouse (Gold Layer)
-- Runs once on first PostgreSQL startup via docker-entrypoint-initdb.d
-- =====================================================================

-- Create a separate database for Airflow metadata
SELECT 'CREATE DATABASE airflow' WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'airflow')\gexec

-- ===== DIMENSION TABLES =====

CREATE TABLE IF NOT EXISTS dim_patient (
    patient_key   SERIAL PRIMARY KEY,
    patient_id    VARCHAR(50) UNIQUE NOT NULL,
    first_name    VARCHAR(100),
    last_name     VARCHAR(100),
    date_of_birth DATE,
    gender        VARCHAR(20),
    blood_type    VARCHAR(10),
    insurance     VARCHAR(100),
    created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS dim_time (
    time_key      SERIAL PRIMARY KEY,
    full_datetime TIMESTAMP NOT NULL,
    date          DATE,
    year          INT,
    quarter       INT,
    month         INT,
    day           INT,
    hour          INT,
    day_of_week   VARCHAR(15),
    is_weekend    BOOLEAN
);

CREATE TABLE IF NOT EXISTS dim_diagnosis (
    diagnosis_key  SERIAL PRIMARY KEY,
    diagnosis_code VARCHAR(20) UNIQUE,
    diagnosis_name VARCHAR(255),
    category       VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS dim_department (
    department_key  SERIAL PRIMARY KEY,
    department_name VARCHAR(100) UNIQUE,
    department_type VARCHAR(50)
);

-- ===== FACT TABLE =====

CREATE TABLE IF NOT EXISTS fact_er_visit (
    visit_key                  SERIAL PRIMARY KEY,
    patient_key                INT REFERENCES dim_patient(patient_key),
    arrival_time_key           INT REFERENCES dim_time(time_key),
    discharge_time_key         INT REFERENCES dim_time(time_key),
    diagnosis_key              INT REFERENCES dim_diagnosis(diagnosis_key),
    department_key             INT REFERENCES dim_department(department_key),
    triage_level               INT,
    wait_time_minutes          INT,
    treatment_duration_minutes INT,
    total_los_minutes          INT,
    disposition                VARCHAR(50),
    satisfaction_score         DECIMAL(3,1)
);

-- ===== INDEXES for common analytical queries =====
CREATE INDEX IF NOT EXISTS idx_fact_patient   ON fact_er_visit(patient_key);
CREATE INDEX IF NOT EXISTS idx_fact_arrival   ON fact_er_visit(arrival_time_key);
CREATE INDEX IF NOT EXISTS idx_fact_diagnosis ON fact_er_visit(diagnosis_key);
CREATE INDEX IF NOT EXISTS idx_fact_department ON fact_er_visit(department_key);
