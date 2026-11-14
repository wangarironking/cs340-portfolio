# Citation for use of AI Tools:
# Date: November 2026
# Prompts submitted to Gemini:
# - Explain Python syntax for implementing SELECT queries across five tables.
# - Explain parameterized INSERT, UPDATE, and DELETE operations
#   for the CustomerClasses table using PyMySQL.
# - Review code for indentation errors and SQL parameter ordering.
#
# Gemini [Large language model]. gemini.google.com
# I reviewed and customized the implementation. The remaining work is my own.

import db_connector as db


class WorkoutRequests:
    

    def sendforcustomers(self):
        query = """
            SELECT customerID, firstName, lastName,
                   emailAddress, phoneNumber
            FROM Customers
            ORDER BY customerID
        """
        return db.fetch_all(query)
    def sendfortrainers(self):
        query = """
            SELECT trainerID, firstName, lastName,
                   emailAddress, trainerSpecialty
            FROM Trainers
            ORDER BY trainerID
        """
        return db.fetch_all(query)
    def sendforstudios(self):
        query = """
            SELECT studioID, roomNumber, roomName, roomLimit
            FROM Studios
            ORDER BY studioID
        """
        return db.fetch_all(query)

    def sendforclasses(self):
        query = """
            SELECT classID, trainerID, className,
                   timeSlot, studioID, classLimit
            FROM Classes
            ORDER BY classID
        """
        return db.fetch_all(query)

    def sendforcustomerclasses(self):
        query = """
            SELECT customerClassID, customerID,
                   classID, bookingDate
            FROM CustomerClasses
            ORDER BY customerClassID
        """
        return db.fetch_all(query)
    
    

    def registeracustomer(self, customerID, classID, bookingDate):
            query = """
                INSERT INTO CustomerClasses
                    (customerID, classID, bookingDate)
                VALUES (%s, %s, %s)
            """
            return db.execute(query, (customerID, classID, bookingDate))

    def modifyregistration(self, customerClassID, customerID, classID, bookingDate):
        query = """
            UPDATE CustomerClasses
            SET customerID = %s,
                classID = %s,
                bookingDate = %s
            WHERE customerClassID = %s
        """
        return db.execute(query, (customerID, classID, bookingDate, customerClassID))

    def destroyregistration(self, customerClassID):
        query = """
            DELETE FROM CustomerClasses
            WHERE customerClassID = %s
        """
        return db.execute(query, (customerClassID,))
