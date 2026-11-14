"""
Database connection utilities for the CS 340 project.

All database access goes through this module so the rest of the
app never touches connection details directly. Credentials are read
from the .env file in the project root (see .env.example).

Citation: Connection pattern adapted from the PyMySQL documentation,
https://pymysql.readthedocs.io/en/latest/user/examples.html
"""

import os

import pymysql
from dotenv import load_dotenv

load_dotenv()


def get_connection():
    """Open and return a new database connection."""
    return pymysql.connect(
        host=os.getenv("DB_HOST", "localhost"),
        port=int(os.getenv("DB_PORT", "3306")),
        user=os.getenv("DB_USER"),
        password=os.getenv("DB_PASSWORD"),
        database=os.getenv("DB_NAME"),
        cursorclass=pymysql.cursors.DictCursor,  # rows come back as dicts
        autocommit=False,
    )


def fetch_all(query, params=None):
    """Run a SELECT and return every row as a list of dicts."""
    conn = get_connection()
    try:
        with conn.cursor() as cur:
            cur.execute(query, params)
            return cur.fetchall()
    finally:
        conn.close()


def execute(query, params=None):
    """
    Run an INSERT, UPDATE, or DELETE and commit it.
    Returns (rows_affected, last_insert_id).
    Rolls back if anything goes wrong.
    """
    conn = get_connection()
    try:
        with conn.cursor() as cur:
            rows = cur.execute(query, params)
            conn.commit()
            return rows, cur.lastrowid
    except Exception:
        conn.rollback()
        raise
    finally:
        conn.close()
