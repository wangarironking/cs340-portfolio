# Team Plan — Workout City Fitness DB

## Roles
Fill in owners together; suggested split from the exploration is shown.

| Responsibility | Owner |
|---|---|
| Maintains main Git repo | Micah |
| Reviews/approves merges | |
| Creates milestone releases | |
| Prepares final submission | |
| Schema and DDL scripts (`sql/DDL.sql`) | |
| Python DB connection (`src/db_connector.py`) | |
| CRUD queries (`sql/DML.sql`, `src/cli.py`) | |
| CLI menu and testing | |

## Milestones
| Milestone | Target date | Due date | Status |
|---|---|---|---|
| Step 1: Proposal and outline | | | Complete |
| Step 2: ERD, schema, sample data, normalization | | | In Progress (reflection TODO) |
| DDL and sample data in repo | | | Complete |
| Proof of concept (Python → DB → CLI) | | | In Progress |
| CRUD on all tables | | | In Progress |
| Application output documentation | | | Not Started |
| Final submission | | | Not Started |

## Task List
Status: Not Started · In Progress · Complete · Tested · Verified

| Task | Owner | Status | Notes |
|---|---|---|---|
| Write Step 2 reflection section | | Not Started | Doc section 01 |
| Run `sql/DDL.sql` on each member's DB | | Not Started | |
| Run `tests/test_connection.py` on each machine | | Not Started | Both members must pass |
| Test CRUD for Customers | | Not Started | |
| Test CRUD for Trainers | | Not Started | |
| Test CRUD for Studios | | Not Started | |
| Test CRUD for Classes | | Not Started | |
| Test CRUD for CustomerClasses + full-class check | | Not Started | |
| Capture CLI output for doc section 08 | | Not Started | |
| Keep ERD/schema images in `docs/` current | | | |
| Verify code citations | | | `docs/citations.md` |
| Review grading rubric before each submission | | | |

## Naming Conventions
- **Tables:** PascalCase, plural (`Customers`, `CustomerClasses`)
- **Columns:** camelCase; PKs are `<singular>ID` (`customerID`)
- **SQL keywords:** uppercase, including `NOT NULL`
- **Python files/modules:** snake_case (`db_connector.py`)
- **Python functions/variables:** snake_case (`class_is_full()`)
- **Docs:** snake_case Markdown (`project_overview.md`)

## Database Approach
- [ ] Each member runs their own local DB from `sql/DDL.sql`
- [ ] Shared development DB (schema scripts still kept in git)

Any schema change goes into `sql/DDL.sql` in the same commit as the code that needs it, and gets announced to the team.
