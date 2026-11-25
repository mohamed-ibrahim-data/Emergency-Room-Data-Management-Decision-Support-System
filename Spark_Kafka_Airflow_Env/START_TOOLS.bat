@echo off
title Start Docker Environment (Spark + Spark Streaming + Kafka + Airflow)
cd /d "%~dp0"

echo ======================================================================
echo   Starting Pure 4-Tool Docker Virtual Environment
echo   Apache Kafka + Apache Spark + Spark Streaming + Apache Airflow
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
echo   Spark Master Web UI    : http://localhost:8082 (RPC: spark://localhost:7077)
echo   Spark Worker Web UI    : http://localhost:8083
echo   Spark Streaming UI     : http://localhost:4040
echo   Airflow Web UI         : http://localhost:8088 (admin / admin)
echo ======================================================================
pause
