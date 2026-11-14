"""
Command-line test driver for the Workout City Fitness DB.

Demonstrates Create, Read, Update and Delete for every table
through a simple menu. Run from the project root:

    python src/cli.py

Each table is described once in ENTITIES below; the generic
menu functions use that description to build their queries.
Table and column names come only from ENTITIES (never from user
input), and every user-entered value is passed as a query
parameter, so the SQL stays safe from injection.

Citation: Original work.
"""

from datetime import date

import pymysql

import db_connector as db


# ---------------------------------------------------------
# Table descriptions
#   pk      primary key column
#   fields  columns the user fills in on add/update
#   hints   optional input hints shown in the prompt
#   list    SELECT used for the Read screen (joins show names, not IDs)
# ---------------------------------------------------------
ENTITIES = {
    "Customers": {
        "pk": "customerID",
        "fields": ["firstName", "lastName", "emailAddress", "phoneNumber"],
        "list": """
            SELECT customerID, firstName, lastName, emailAddress, phoneNumber
            FROM Customers ORDER BY customerID;""",
    },
    "Trainers": {
        "pk": "trainerID",
        "fields": ["firstName", "lastName", "emailAddress", "trainerSpecialty"],
        "list": """
            SELECT trainerID, firstName, lastName, emailAddress, trainerSpecialty
            FROM Trainers ORDER BY trainerID;""",
    },
    "Studios": {
        "pk": "studioID",
        "fields": ["roomNumber", "roomName", "roomLimit"],
        "list": """
            SELECT studioID, roomNumber, roomName, roomLimit
            FROM Studios ORDER BY studioID;""",
    },
    "Classes": {
        "pk": "classID",
        "fields": ["className", "timeSlot", "trainerID", "studioID", "classLimit"],
        "hints": {"timeSlot": "YYYY-MM-DD HH:MM"},
        "list": """
            SELECT c.classID, c.className, c.timeSlot,
                   CONCAT(t.firstName, ' ', t.lastName) AS trainer,
                   s.roomName AS studio,
                   COUNT(cc.customerClassID) AS enrolled, c.classLimit
            FROM Classes c
            JOIN Trainers t ON t.trainerID = c.trainerID
            JOIN Studios  s ON s.studioID  = c.studioID
            LEFT JOIN CustomerClasses cc ON cc.classID = c.classID
            GROUP BY c.classID
            ORDER BY c.timeSlot;""",
    },
    "CustomerClasses": {
        "pk": "customerClassID",
        "fields": ["customerID", "classID", "bookingDate"],
        "hints": {"bookingDate": "YYYY-MM-DD"},
        "list": """
            SELECT cc.customerClassID,
                   CONCAT(cu.firstName, ' ', cu.lastName) AS customer,
                   cl.className, cl.timeSlot, cc.bookingDate
            FROM CustomerClasses cc
            JOIN Customers cu ON cu.customerID = cc.customerID
            JOIN Classes   cl ON cl.classID    = cc.classID
            ORDER BY cc.bookingDate, cc.customerClassID;""",
    },
}


# ---------------------------------------------------------
# Helpers
# ---------------------------------------------------------

def print_rows(rows):
    """Print a list of dict rows as an aligned text table."""
    if not rows:
        print("(no rows)")
        return
    cols = list(rows[0].keys())
    widths = {c: max(len(c), *(len(str(r[c])) for r in rows)) for c in cols}
    print()
    print("  ".join(c.ljust(widths[c]) for c in cols))
    print("  ".join("-" * widths[c] for c in cols))
    for r in rows:
        print("  ".join(str(r[c]).ljust(widths[c]) for c in cols))


def prompt(field, entity, current=None):
    """Ask for one field. On update, a blank answer keeps the current value."""
    hint = entity.get("hints", {}).get(field)
    label = field + (f" ({hint})" if hint else "")
    if current is not None:
        answer = input(f"{label} [{current}]: ").strip()
        return current if answer == "" else answer
    if field == "bookingDate":
        answer = input(f"{label} [today]: ").strip()
        return answer or date.today().isoformat()
    return input(f"{label}: ").strip()


def class_is_full(class_id):
    """Return True if the class already has classLimit enrollments."""
    rows = db.fetch_all(
        """SELECT c.classLimit, COUNT(cc.customerClassID) AS enrolled
           FROM Classes c
           LEFT JOIN CustomerClasses cc ON cc.classID = c.classID
           WHERE c.classID = %s
           GROUP BY c.classID;""",
        (class_id,),
    )
    if not rows:
        return False  # unknown class; the FK constraint will reject it
    return rows[0]["enrolled"] >= rows[0]["classLimit"]


# ---------------------------------------------------------
# Generic CRUD
# ---------------------------------------------------------

def read_all(table):
    print_rows(db.fetch_all(ENTITIES[table]["list"]))


def create(table):
    entity = ENTITIES[table]
    values = [prompt(f, entity) for f in entity["fields"]]

    # Prevent over-enrollment, the core problem this DB solves
    if table == "CustomerClasses" and class_is_full(values[1]):
        print("That class is full. Enrollment not added.")
        return

    cols = ", ".join(entity["fields"])
    marks = ", ".join(["%s"] * len(values))
    _, new_id = db.execute(f"INSERT INTO {table} ({cols}) VALUES ({marks});", values)
    print(f"Added {table} row #{new_id}.")


def update(table):
    entity = ENTITIES[table]
    pk = entity["pk"]
    row_id = input(f"{pk} to update: ").strip()
    rows = db.fetch_all(f"SELECT * FROM {table} WHERE {pk} = %s;", (row_id,))
    if not rows:
        print(f"No {table} row with {pk} {row_id}.")
        return

    print("Press Enter to keep the current value.")
    current = rows[0]
    values = [prompt(f, entity, current[f]) for f in entity["fields"]]

    # Moving an enrollment into a different, already-full class
    if (table == "CustomerClasses"
            and str(values[1]) != str(current["classID"])
            and class_is_full(values[1])):
        print("That class is full. Enrollment not changed.")
        return

    assignments = ", ".join(f"{f} = %s" for f in entity["fields"])
    db.execute(f"UPDATE {table} SET {assignments} WHERE {pk} = %s;", [*values, row_id])
    print("Updated.")


def delete(table):
    pk = ENTITIES[table]["pk"]
    row_id = input(f"{pk} to delete: ").strip()
    count, _ = db.execute(f"DELETE FROM {table} WHERE {pk} = %s;", (row_id,))
    print("Deleted." if count else f"No {table} row with {pk} {row_id}.")


# ---------------------------------------------------------
# Menus
# ---------------------------------------------------------

ACTIONS = {
    "1": ("List all", read_all),
    "2": ("Add", create),
    "3": ("Update", update),
    "4": ("Delete", delete),
}


def table_menu(table):
    while True:
        print(f"\n--- {table} ---")
        for key, (label, _) in ACTIONS.items():
            print(f"{key}. {label}")
        print("b. Back")
        choice = input("> ").strip().lower()
        if choice == "b":
            return
        action = ACTIONS.get(choice)
        if action is None:
            print("Invalid choice.")
            continue
        try:
            action[1](table)
        except pymysql.err.IntegrityError as e:
            # FK violations, duplicate emails, double enrollment, etc.
            print(f"Not allowed: {e.args[1] if len(e.args) > 1 else e}")
        except pymysql.MySQLError as e:
            print(f"Database error: {e}")


def main():
    tables = list(ENTITIES)
    while True:
        print("\n=== Workout City Fitness DB ===")
        for i, name in enumerate(tables, start=1):
            print(f"{i}. {name}")
        print("q. Quit")
        choice = input("> ").strip().lower()
        if choice == "q":
            break
        if choice.isdigit() and 1 <= int(choice) <= len(tables):
            table_menu(tables[int(choice) - 1])
        else:
            print("Invalid choice.")


if __name__ == "__main__":
    main()
