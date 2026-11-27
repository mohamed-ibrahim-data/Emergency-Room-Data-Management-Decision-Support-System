# Emergency Room Data Engineering — Docker Infrastructure

Complete Medallion Architecture (Bronze → Silver → Gold) infrastructure containing **7 containerized services** managed by Docker Compose:

| # | Tool | Container(s) | Host Endpoint / UI | Internal Docker Endpoint | Credentials / Details |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 1 | **Apache Kafka 3.9** *(KRaft)* | `kafka` | `localhost:9092` | `kafka:29092` | No ZooKeeper required; auto-topic creation enabled |
| 2 | **PostgreSQL 16** *(Gold Layer)* | `postgres` | `localhost:5432` | `postgres:5432` | User: `er_admin` · Pass: `er_password` · DB: `er_data_warehouse` |
| 3 | **Apache Spark 3.5.3** | `spark-master`, `spark-worker` | Master UI: http://localhost:8082<br>Worker UI: http://localhost:8083 | `spark://spark-master:7077` | Isolated `/opt/venv` inside `Dockerfile.spark` |
| 4 | **Spark Streaming 3.5.3** | `spark-streaming` | Driver UI: http://localhost:4040 | Uses `kafka:29092` & `spark://spark-master:7077` | Pre-loaded with `spark-sql-kafka-0-10` & `spark-streaming-kafka-0-10` JARs |
| 5 | **Apache Airflow 2.10.4** | `airflow` | Web UI: http://localhost:8088 | Pre-wired `spark_default`, `kafka_default` & `postgres_default` | Login: `admin` / `admin` · PostgreSQL metadata backend |
| 6 | **Grafana 11** | `grafana` | Dashboards: http://localhost:3000 | Auto-provisioned PostgreSQL datasource | Login: `admin` / `admin` |

---

## Medallion Architecture

```text
Python (Data Simulation)
    ├── Batch Data (CSV/JSON)
    └── Apache Kafka (Streaming)
            │
            ▼
    ┌─────────────────────────┐
    │  BRONZE LAYER (Raw)     │  ./data/bronze/
    │  Parquet — append-only  │  Ingested from batch & Kafka
    └─────────────────────────┘
            │
            ▼
    ┌─────────────────────────┐
    │  SILVER LAYER (Cleaned) │  ./data/silver/
    │  Parquet — validated    │  Apache Spark cleaning & transformation
    └─────────────────────────┘
            │
            ▼
    ┌─────────────────────────┐
    │  GOLD LAYER (DWH)       │  PostgreSQL
    │  Star Schema tables     │  Dimension & Fact tables
    └─────────────────────────┘
            │
            ▼
    ┌─────────────────────────┐
    │  Grafana                │  Dashboards, Monitoring & Alerts
    └─────────────────────────┘
```

---

## Folder Structure

```text
Spark_Kafka_Airflow_Env/
├── docker-compose.yml            # Orchestrates all 7 services
├── Dockerfile.spark              # Spark 3.5.3 + Kafka JARs + PostgreSQL JDBC + /opt/venv
├── Dockerfile.airflow            # Airflow 2.10.4 + OpenJDK 17 + Spark/Kafka/Postgres providers
├── requirements.spark.txt        # Packages inside Spark's /opt/venv
├── requirements.airflow.txt      # Packages inside Airflow
├── requirements.txt              # Packages for local Windows .venv (IDE & CLI)
├── .env                          # Ports, memory caps, credentials
├── START_TOOLS.bat               # Builds & starts all services in Docker
├── STOP_TOOLS.bat                # Stops all containers
├── SETUP_VENV.bat                # Creates & activates local Windows .venv
├── airflow/
│   ├── dags/                     # Drop your Airflow DAGs here → /opt/airflow/dags
│   ├── logs/                     # Airflow task logs
│   └── plugins/                  # Airflow plugins
├── spark/
│   ├── jobs/                     # Drop batch PySpark scripts here → /opt/spark-jobs
│   └── streaming/                # Drop Spark Streaming scripts here → /opt/spark-streaming
├── data/
│   ├── bronze/                   # Bronze Layer — Raw Parquet files
│   └── silver/                   # Silver Layer — Cleaned Parquet files
├── postgres/
│   └── init/                     # SQL init scripts (run on first startup)
│       └── 01_create_star_schema.sql
├── grafana/
│   └── provisioning/
│       └── datasources/
│           └── postgres.yml      # Auto-provisions PostgreSQL datasource
├── d.generator/
│   └── faker.py                  # Python data simulation script
└── dataset/                      # Sample CSV datasets
```

---

## Quick Start

### 1. Start the Docker Stack
Make sure **Docker Desktop** is open and running, then double-click `START_TOOLS.bat` or run:
```powershell
docker compose up -d --build
docker compose ps
```

### 2. Activate the Local Python Virtual Environment (`.venv`)
Double-click `SETUP_VENV.bat`, or in PowerShell:
```powershell
.\.venv\Scripts\Activate.ps1
```

---

## Useful Tool Commands

### Kafka (Create / List Topics, Console Producer & Consumer)
```powershell
docker exec -it kafka /opt/kafka/bin/kafka-topics.sh --bootstrap-server localhost:9092 --create --topic test-topic --partitions 3 --replication-factor 1
docker exec -it kafka /opt/kafka/bin/kafka-topics.sh --bootstrap-server localhost:9092 --list
```

### Spark Batch (`spark-submit` or Interactive `pyspark` Shell)
```powershell
# Interactive PySpark shell (runs inside /opt/venv)
docker exec -it spark-master pyspark --master spark://spark-master:7077

# Submit a batch script placed in ./spark/jobs/
docker exec -it spark-master spark-submit --master spark://spark-master:7077 /opt/spark-jobs/your_job.py
```

### Spark Streaming (Submit a Kafka Streaming Script)
```powershell
# Submit manually from ./spark/streaming/
docker exec -it spark-streaming spark-submit --master spark://spark-master:7077 /opt/spark-streaming/your_stream.py
```
*(Or set `STREAMING_JOB=your_stream.py` in `.env` so `spark-streaming` runs it automatically on container startup.)*

### PostgreSQL (Connect to Data Warehouse)
```powershell
# Interactive psql shell
docker exec -it postgres psql -U er_admin -d er_data_warehouse

# List star schema tables
docker exec -it postgres psql -U er_admin -d er_data_warehouse -c "\dt"
```

### Grafana
Open http://localhost:3000 and log in with `admin` / `admin`. The PostgreSQL datasource (`ER Data Warehouse`) is auto-provisioned.

### Airflow CLI
```powershell
docker exec -it airflow airflow dags list
docker exec -it airflow airflow connections list
```
