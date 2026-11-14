"""
Smoke test: confirms Python can reach the database and the
Workout City schema and sample data are loaded.
Every team member should be able to run this successfully.

Run from the project root:  python tests/test_connection.py
(Also works with pytest if you install it.)

Citation: Original work.
"""

import os
import sys

sys.path.insert(0, os.path.join(os.path.dirname(__file__), "..", "src"))

import db_connector as db  # noqa: E402

TABLES = ["Customers", "Trainers", "Studios", "Classes", "CustomerClasses"]


def test_connection():
    rows = db.fetch_all("SELECT 1 AS ok;")
    assert rows[0]["ok"] == 1


def test_sample_data_loaded():
    for table in TABLES:
        rows = db.fetch_all(f"SELECT COUNT(*) AS n FROM {table};")
        assert rows[0]["n"] > 0, f"No rows in {table}. Did you run sql/DDL.sql?"


if __name__ == "__main__":
    test_connection()
    print("Connection OK")
    test_sample_data_loaded()
    print("Sample data OK in: " + ", ".join(TABLES))
