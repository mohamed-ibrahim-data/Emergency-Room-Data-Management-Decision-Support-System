@echo off
title Start Docker Environment (ER Data Engineering — Full Tech Stack)
cd /d "%~dp0"

echo ======================================================================
echo   Starting Emergency Room Data Engineering Docker Environment
echo   Kafka + PostgreSQL + Spark + Spark Streaming + Airflow + Grafana
echo ======================================================================
echo.

docker info >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Docker Desktop daemon is not running!
    echo Please open Docker Desktop, wait until it says "Engine running", and try again.
    pause
    exit /b 1
)

if not exist ".env" (
    if exist ".env.example" copy /y ".env.example" ".env" >nul
)

echo [1/2] Building Docker virtual environments and starting services...
docker compose up -d --build
if errorlevel 1 (
    echo [ERROR] Docker Compose failed to start.
    pause
    exit /b 1
)

echo.
echo [2/2] Container Status:
docker compose ps
echo.
echo ======================================================================
echo   Kafka Broker           : localhost:9092 (internal: kafka:29092)
echo   PostgreSQL (Gold DWH)  : localhost:5432 (er_admin / er_password)
echo   Spark Master Web UI    : http://localhost:8082 (RPC: spark://localhost:7077)
echo   Spark Worker Web UI    : http://localhost:8083
echo   Spark Worker 2 Web UI  : http://localhost:8084
echo   Spark Streaming UI     : http://localhost:4040
echo   Airflow Web UI         : http://localhost:8088 (admin / admin)
echo   Grafana Dashboards     : http://localhost:3000 (admin / admin)
echo   JupyterLab (PySpark)   : http://localhost:8888 (Spark UI: :4041)
echo ======================================================================
pause
