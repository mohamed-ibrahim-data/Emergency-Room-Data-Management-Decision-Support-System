@echo off
title Setup ER Platform Python Virtual Environment (.venv)
cd /d "%~dp0"

if not exist ".venv\Scripts\python.exe" (
    echo [1/3] Creating Python virtual environment (.venv)...
    python -m venv .venv
)

echo [2/3] Installing ER Platform Python libraries (Web, Data, ML/XAI, DB, Reporting)...
call ".venv\Scripts\activate.bat"
python -m pip install --upgrade pip
python -m pip install -r requirements.txt

echo.
echo [3/3] Verifying installed libraries...
python VERIFY_LIBS.py
pause
