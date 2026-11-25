"""Verifies the 21 ER Platform Python libraries (excluding Spark/Kafka/Airflow Docker tools)."""

import importlib

ER_PYTHON_LIBRARIES = [
    ("fastapi", "FastAPI Web Backend"),
    ("uvicorn", "ASGI Server"),
    ("pydantic", "Data Validation & Schemas"),
    ("pandas", "DataFrames & ETL"),
    ("numpy", "Numerical Computing"),
    ("pyarrow", "Columnar / Parquet Storage"),
    ("duckdb", "Analytical Data Warehouse Engine"),
    ("faker", "Synthetic ER Patient/Visit Data"),
    ("sklearn", "Scikit-Learn ML Models & Metrics"),
    ("scipy", "Scientific Computing"),
    ("xgboost", "XGBoost Clinical Risk Models"),
    ("imblearn", "Imbalanced-Learn (Class Balancing)"),
    ("optuna", "Hyperparameter Optimization"),
    ("shap", "SHAP Clinical Model Explainability"),
    ("joblib", "ML Model Persistence (.joblib)"),
    ("sqlalchemy", "SQL Toolkit & ORM"),
    ("psycopg2", "PostgreSQL Driver"),
    ("redis", "Real-Time Cache Client"),
    ("matplotlib", "Plotting & Charts"),
    ("seaborn", "Statistical Visualization"),
    ("reportlab", "PDF Technical & Clinical Reports"),
]

STDLIB_MODULES = [
    "argparse", "base64", "csv", "dataclasses", "datetime", "glob",
    "hashlib", "heapq", "hmac", "html", "http", "json", "math",
    "os", "pathlib", "random", "re", "secrets", "socketserver",
    "sqlite3", "subprocess", "sys", "time", "typing", "urllib",
]


def main():
    print("=" * 72)
    print("  ER Platform - Pure Python Libraries Check (No Docker Tool Overlap)")
    print("=" * 72)
    missing = []
    for mod_name, role in ER_PYTHON_LIBRARIES:
        try:
            mod = importlib.import_module(mod_name)
            ver = getattr(mod, "__version__", "installed")
            print(f"  [OK] {mod_name:<14} v{str(ver):<12} - {role}")
        except Exception as exc:
            print(f"  [MISSING] {mod_name:<9} ({exc})")
            missing.append(mod_name)

    for std_mod in STDLIB_MODULES:
        importlib.import_module(std_mod)
    print("-" * 72)
    print(f"  Python Standard Library modules verified : {len(STDLIB_MODULES)}/{len(STDLIB_MODULES)}")
    print(f"  ER Platform Python libraries ready       : {len(ER_PYTHON_LIBRARIES) - len(missing)}/{len(ER_PYTHON_LIBRARIES)}")
    print("=" * 72)
    if missing:
        raise SystemExit(f"Missing packages: {', '.join(missing)}")


if __name__ == "__main__":
    main()
