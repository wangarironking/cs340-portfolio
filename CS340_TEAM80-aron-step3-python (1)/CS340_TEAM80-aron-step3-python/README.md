# CS 340 Team 80 — Workout City Fitness DB

A database for Workout City, a local fitness center with about 400 customers and 20+ weekly classes across 4 studio rooms. It tracks customers, trainers, studios, classes, and class enrollments, and blocks enrollment once a class is full. A Python data access layer and a command-line menu demonstrate CRUD on every table. The project includes a Python application class supporting SELECT operations on all five tables and INSERT, UPDATE, and DELETE operations on CustomerClasses. An interactive CLI also provides CRUD functionality and checks class capacity.

**Team:** Aron Wang, Micah Ahn · **Mentor:** Michael L Curry

**Tables:** Customers, Trainers, Studios, Classes, CustomerClasses (intersection table for Customers ↔ Classes)

## Project structure

```
docs/    Project overview, team plan, ERD and schema diagrams, citations
sql/     DDL.sql (schema) and DML.sql (queries used by the app)
src/     db_connector.py (data access)
         cli.py (CLI test driver)
         workout_city_app.py (Python CRUD application class)
tests/   test_connection.py (database connection test)
         pythonCrudTesting.py (CRUD driver script)
CLI_OUT.txt   Output from the CRUD driver script
```

## Setup

1. **Clone the repo**
   ```bash
   git clone <repo-url>
   cd CS340_TEAM80
   ```
2. **Create a virtual environment and install dependencies**
   ```bash
   python3 -m venv .venv
   source .venv/bin/activate        # Windows: .venv\Scripts\activate
   pip install -r requirements.txt
   ```
3. **Configure your database credentials**
   ```bash
   cp .env.example .env
   ```
   Then fill in `.env` with your own MySQL/MariaDB credentials. `.env` is git-ignored, so never commit it.
4. **Create the schema and load sample data**
   ```bash
   mysql -u <user> -p <database> < sql/DDL.sql
   ```
5. **Check the connection**
   ```bash
   python tests/test_connection.py
   ```
6. **Run the CLI**
   ```bash
   python src/cli.py
   ```
7. **Run the Python CRUD driver**
   ```bash
   python tests/pythonCrudTesting.py
   ```
   Demonstrates SELECT operations on all five tables and
   INSERT, UPDATE, and DELETE operations on CustomerClasses.

8. **Generate the execution output**
   ```bash
   python tests/pythonCrudTesting.py > CLI_OUT.txt
   ```
   Saves the results of the CRUD demonstration to CLI_OUT.txt.

## Git workflow

- `main` always holds working, tested code.
- Make a branch per feature: `git checkout -b feature/<short-name>`.
- Pull often: `git pull origin main`.
- Open a pull request into `main`; a teammate reviews before merging.

## Citations

See [docs/citations.md](docs/citations.md). Every file that uses outside code must cite it there and in a comment at the top of the file.
