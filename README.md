# Emergency Room Data Warehouse

## Data Dictionary

The data warehouse follows a Star Schema consisting of four dimension tables and one fact table. Each record in the fact table represents one emergency room visit.

## Dimension Tables

### 1. `dim_patient`

Stores patient demographic and insurance information.

| Column | Data Type | Hint | Example |
|---|---|---|---|
| `patient_key` | SERIAL | Auto-generated surrogate primary key. | 1 |
| `patient_id` | VARCHAR(50) | Unique patient identifier from the source system. | PAT-1001 |
| `first_name` | VARCHAR(100) | Patient's first name. | Ahmed |
| `last_name` | VARCHAR(100) | Patient's last name. | Hassan |
| `date_of_birth` | DATE | Patient's birth date. | 1998-05-15 |
| `gender` | VARCHAR(20) | Recorded patient gender. | Male |
| `blood_type` | VARCHAR(10) | Patient's blood group. | A+ |
| `insurance` | VARCHAR(100) | Patient's insurance provider or coverage type. | Private Insurance |
| `created_at` | TIMESTAMP | Record creation timestamp; defaults to the current timestamp. | 2026-11-28 10:30:00 |

### 2. `dim_time`

Stores date and time attributes for temporal analysis of ER visits.

| Column | Data Type | Hint | Example |
|---|---|---|---|
| `time_key` | SERIAL | Auto-generated surrogate primary key. | 105 |
| `full_datetime` | TIMESTAMP | Complete date and time. | 2026-11-28 14:35:00 |
| `date` | DATE | Calendar date without time. | 2026-11-28 |
| `year` | INT | Calendar year. | 2026 |
| `quarter` | INT | Quarter of the year (1–4). | 4 |
| `month` | INT | Month of the year (1–12). | 11 |
| `day` | INT | Day of the month. | 28 |
| `hour` | INT | Hour of the day (0–23). | 14 |
| `day_of_week` | VARCHAR(15) | Name of the weekday. | Saturday |
| `is_weekend` | BOOLEAN | Indicates whether the date falls on a weekend, according to the project's calendar. | TRUE |

### 3. `dim_diagnosis`

Stores medical diagnosis codes, names, and categories.

| Column | Data Type | Hint | Example |
|---|---|---|---|
| `diagnosis_key` | SERIAL | Auto-generated surrogate primary key. | 15 |
| `diagnosis_code` | VARCHAR(20) | Unique diagnosis code, such as an ICD-10 code. | J45 |
| `diagnosis_name` | VARCHAR(255) | Name of the medical diagnosis. | Asthma |
| `category` | VARCHAR(100) | Medical classification of the diagnosis. | Respiratory Diseases |

### 4. `dim_department`

Stores information about medical departments associated with ER visits.

| Column | Data Type | Hint | Example |
|---|---|---|---|
| `department_key` | SERIAL | Auto-generated surrogate primary key. | 1 |
| `department_name` | VARCHAR(100) | Unique department name. | Cardiology |
| `department_type` | VARCHAR(50) | Department classification or service type. | Specialty |

## Fact Table

### 5. `fact_er_visit`

Stores ER visits, operational metrics, and visit outcomes.

**Grain:** One row per emergency room visit.

| Column | Data Type | Hint | Example |
|---|---|---|---|
| `visit_key` | SERIAL | Auto-generated surrogate primary key for each visit record. | 1001 |
| `patient_key` | INT | Foreign key referencing `dim_patient`. | 1 |
| `arrival_time_key` | INT | Foreign key referencing `dim_time` for patient arrival. | 105 |
| `discharge_time_key` | INT | Foreign key referencing `dim_time` for ER departure. | 106 |
| `diagnosis_key` | INT | Foreign key referencing `dim_diagnosis`. | 15 |
| `department_key` | INT | Foreign key referencing `dim_department`. | 1 |
| `triage_level` | INT | Patient acuity or urgency level. | 2 |
| `wait_time_minutes` | INT | Time spent waiting before treatment begins, in minutes. | 30 |
| `treatment_duration_minutes` | INT | Duration of treatment, in minutes. | 60 |
| `total_los_minutes` | INT | Total length of stay from arrival to ER departure, in minutes. | 120 |
| `disposition` | VARCHAR(50) | Final outcome of the ER visit. | Discharged |
| `satisfaction_score` | DECIMAL(3,1) | Patient satisfaction rating. | 4.5 |

> All example values are illustrative. Metric definitions, triage levels, satisfaction scales, and weekend rules should follow the project's agreed business rules.
