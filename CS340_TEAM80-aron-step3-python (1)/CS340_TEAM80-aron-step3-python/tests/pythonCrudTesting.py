# Citation for use of AI Tools:
# Date: November 2026
# Prompts submitted to Gemini:
# - Explain how to create a Python driver script to test CRUD methods.
# - Demonstrate calling SELECT, INSERT, UPDATE, and DELETE methods.
# - Explain how to use the ID returned by INSERT for UPDATE and DELETE tests.
#
# Gemini [Large language model]. gemini.google.com
# I reviewed and customized the implementation based on Gemini's template
# The remaining work is my own.

import os
import sys

sys.path.insert(0, os.path.join(os.path.dirname(__file__), "..", "src"))

from workout_city_app import WorkoutRequests


app = WorkoutRequests()

print("=== Customers ===")
print(app.sendforcustomers())

print("=== Trainers ===")
print(app.sendfortrainers())

print("=== Studios ===")
print(app.sendforstudios())

print("=== Classes ===")
print(app.sendforclasses())

print("=== Customer Classes ===")
print(app.sendforcustomerclasses())

print("=== INSERT Registration ===")

rows, new_id = app.registeracustomer(5, 1, "2026-11-01")
print("Inserted registration ID:", new_id)


print("=== UPDATE Registration ===")

print(app.modifyregistration(new_id, 5, 2, "2026-11-02"))


print("=== DELETE Registration ===")

print(app.destroyregistration(new_id))
