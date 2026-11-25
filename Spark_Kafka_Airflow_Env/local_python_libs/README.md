# ER Platform — Python Libraries Only (`.venv`)

Contains **only** the local Python virtual environment (`.venv`) and packages for the ER Platform's Web API, Data Processing, Machine Learning/XAI, Databases, and PDF Reporting.

> **Zero Overlap:** Big-data Docker tools (**Spark, Spark Streaming, Kafka, Airflow**) and all `Dockerfile`s live exclusively in [`../spark_kafka_airflow_env`](../spark_kafka_airflow_env).

---

## Included Python Libraries (21 Packages)

| Category | `pip` Package | Python `import` | Role in ER Platform |
| :--- | :--- | :--- | :--- |
| **Web API & Backend** | `fastapi` | `fastapi` | Hospital Command REST API |
| **Web API & Backend** | `uvicorn[standard]` | `uvicorn` | ASGI web server |
| **Web API & Backend** | `pydantic` | `pydantic` | Clinical payload validation & schemas |
| **Data & Analytics** | `pandas` | `pandas` | Tabular ETL & feature preparation |
| **Data & Analytics** | `numpy` | `numpy` | Numerical arrays & vitals math |
| **Data & Analytics** | `pyarrow` | `pyarrow` | Parquet columnar storage |
| **Data & Analytics** | `duckdb` | `duckdb` | Analytical OLAP queries |
| **Data & Analytics** | `Faker` | `faker` | Synthetic ER encounter generation |
| **Machine Learning & XAI** | `scikit-learn` | `sklearn` | Triage, LOS, admission & mortality models |
| **Machine Learning & XAI** | `scipy` | `scipy` | Scientific & statistical routines |
| **Machine Learning & XAI** | `xgboost` | `xgboost` | Gradient-boosted clinical risk models |
| **Machine Learning & XAI** | `imbalanced-learn` | `imblearn` | Rare clinical event class balancing |
| **Machine Learning & XAI** | `optuna` | `optuna` | Automated hyperparameter tuning |
| **Machine Learning & XAI** | `shap` | `shap` | Explainable AI (SHAP feature attributions) |
| **Machine Learning & XAI** | `joblib` | `joblib` | `.joblib` model serialization |
| **Databases & Cache** | `sqlalchemy` | `sqlalchemy` | SQL ORM & connection management |
| **Databases & Cache** | `psycopg2-binary` | `psycopg2` | PostgreSQL driver |
| **Databases & Cache** | `redis` | `redis` | Live ED bed/occupancy cache client |
| **Charts & PDF Reports** | `matplotlib` | `matplotlib` | Model evaluation & KPI plots |
| **Charts & PDF Reports** | `seaborn` | `seaborn` | Statistical visualizations |
| **Charts & PDF Reports** | `reportlab` | `reportlab` | Automated PDF report generation |
