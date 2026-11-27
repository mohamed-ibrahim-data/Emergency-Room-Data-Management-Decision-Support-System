@echo off
title Local Python Virtual Environment (.venv) — Tools Only
cd /d "%~dp0"

if not exist ".venv\Scripts\python.exe" (
    echo [1/2] Creating local Python virtual environment in .venv ...
    python -m venv .venv
)

echo [2/2] Installing Spark, Kafka, and Airflow client packages into .venv ...
call ".venv\Scripts\activate.bat"
python -m pip install --upgrade pip
python -m pip install -r requirements.txt

echo.
echo ======================================================================
echo   Local virtual environment (.venv) is active!
echo   To activate later in PowerShell : .\.venv\Scripts\Activate.ps1
echo   To activate later in CMD        : .venv\Scripts\activate.bat
echo ======================================================================
cmd /k
