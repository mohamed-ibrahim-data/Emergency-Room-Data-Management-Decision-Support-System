@echo off
title Stop Docker Environment (ER Data Engineering — Full Tech Stack)
cd /d "%~dp0"

echo Stopping all ER Data Engineering containers (Kafka, PostgreSQL, Spark, Airflow, Grafana)...
docker compose down
echo Done!
pause
