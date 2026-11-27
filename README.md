# Emergency-Room-Data-Management-Decision-Support-System


## Infrastructure & JupyterLab (PySpark)

- **JupyterLab**: `http://localhost:8888` (Spark Driver UI: `http://localhost:4041`)
  - Connected to `spark://spark-master:7077` using the shared `local/spark-venv:3.5.3` image (`/opt/venv`).
  - Notebooks directory: `./notebooks` (mounted at `/opt/notebooks`). Includes `00_test_spark_cluster.ipynb`.
  - Pre-configured with `PYSPARK_SUBMIT_ARGS` (`spark.driver.host=jupyter`), Kafka streaming JARs, PostgreSQL JDBC driver, and mounts to `/opt/data/bronze`, `/opt/data/silver`, and `/opt/dataset`.
