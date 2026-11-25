# Spark + Spark Streaming + Kafka + Airflow — Docker Virtual Environment

Clean, zero-bloat infrastructure environment containing **only** the 4 tools below (no application code, no extra databases/services):

| Tool | Container(s) | Host Endpoint / UI | Internal Docker Endpoint | Credentials / Details |
| :--- | :--- | :--- | :--- | :--- |
| **Apache Kafka 3.9** *(KRaft)* | `kafka` | `localhost:9092` | `kafka:29092` | No ZooKeeper required; auto-topic creation enabled |
| **Apache Spark 3.5.3** | `spark-master`, `spark-worker` | Master UI: http://localhost:8082<br>Worker UI: http://localhost:8083 | `spark://spark-master:7077` | Isolated `/opt/venv` inside `Dockerfile.spark` |
| **Spark Streaming 3.5.3** | `spark-streaming` | Driver UI: http://localhost:4040 | Uses `kafka:29092` & `spark://spark-master:7077` | Pre-loaded with `spark-sql-kafka-0-10` & `spark-streaming-kafka-0-10` JARs |
| **Apache Airflow 2.10.4** | `airflow` | Web UI: http://localhost:8088 | Pre-wired `spark_default` & `kafka_default` | Login: `admin` / `admin` · Java 17 + Spark & Kafka providers pre-installed |

---

## Folder Structure (Tools & Mounts Only)

```text
spark_kafka_airflow_env/
├── docker-compose.yml         # Orchestrates Kafka, Spark, Spark Streaming, and Airflow
├── Dockerfile.spark           # Spark 3.5.3 + Kafka Streaming JARs + isolated /opt/venv
├── Dockerfile.airflow         # Airflow 2.10.4 + OpenJDK 17 + Spark/Kafka providers
├── requirements.spark.txt     # Packages inside Spark's /opt/venv
├── requirements.airflow.txt   # Packages inside Airflow
├── requirements.txt           # Packages for local Windows .venv (IDE & CLI)
├── .env                       # Ports, memory caps, and Airflow credentials
├── START_TOOLS.bat            # Builds & starts all 4 tools in Docker
├── STOP_TOOLS.bat             # Stops all containers
├── SETUP_VENV.bat             # Creates & activates local Windows .venv
├── airflow/
│   ├── dags/                  # Drop your Airflow DAGs here -> /opt/airflow/dags
│   ├── logs/                  # Airflow task logs
│   └── plugins/               # Airflow plugins
├── spark/
│   ├── jobs/                  # Drop batch PySpark scripts here -> /opt/spark-jobs
│   └── streaming/             # Drop Spark Streaming scripts here -> /opt/spark-streaming
└── data/                      # Shared volume across Spark, Spark Streaming & Airflow -> /opt/data
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

### Airflow CLI
```powershell
docker exec -it airflow airflow dags list
docker exec -it airflow airflow connections list
```
