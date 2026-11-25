@echo off
title Stop Docker Environment (Spark + Spark Streaming + Kafka + Airflow)
cd /d "%~dp0"

echo Stopping Spark, Spark Streaming, Kafka, and Airflow containers...
docker compose down
echo Done!
pause
