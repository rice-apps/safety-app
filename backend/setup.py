import sqlite3 as lite
import os


def make_dicts(cursor, row):
    return dict((cursor.description[idx][0], value) for idx, value in enumerate(row))

#remove the database if it exists
if os.path.exists("wellbeing.db"):
    os.remove("wellbeing.db")

#create connection to database and its cursor
con = lite.connect("wellbeing.db", check_same_thread=False)
con.row_factory = make_dicts
cur = con.cursor()


#initialize the database with wellbeing resources
def init_db():
    with con:
        cur.execute("""DROP TABLE IF EXISTS important_numbers""")
        cur.execute("""CREATE TABLE important_numbers(
                    name TEXT,
                    number TEXT,
                    onCampus INTEGER,
                    allDay INTEGER,
                    description TEXT);""")
        insert_number()
        con.commit()


def init_tracking():
    with con:
        cur.execute("""DROP TABLE IF EXISTS tracking""")
        cur.execute("""CREATE TABLE tracking(
                    UUID TEXT,
                    longitude REAL,
                    latitude REAL,
                    time TEXT);""")
        con.commit()


#insert the numbers of wellbeing resources into the database
def insert_number():
    data = [("RUPD/EMS", "(713)348-6000", 1, 1, "Immediate medical attention or in danger. For emergency."),
            ("Student Wellbeing Office", "(713)348-3311", 1, 0, "For support through issues affecting personal or "
                                                                "academic goals, including sexual misconduct or other "
                                                                "traumas."),
            ("Student Judicial Programs", "(713)348-4786", 1, 0, "If it is not urgent, but someone's behavior is "
                                                                 "troubling, please contact SJP."),
            ("Rice Counseling Center", "(713)348-4867", 1, 1, "Counseling services."),
            ("Student Health Services", "(713)348-4966", 1, 0, "For physical health concerns."),
            ("Office of Academic Advising", "(713)348-4060", 1, 0, "General academic concerns for undergraduates."),
            ("Disability Support Services", "(713)348-5841", 1, 0, "Accommodations for a disability."),
            ("Dean of Undergraduates", "(713)348-4996", 1, 0, "General support for undergraduates."),
            ("Graduate and Postdoctoral Studies", "(713)348-4002", 1, 0, "Gernal support for graduate students."),
            ("Houston Area Women's Center", "(713)528-7273", 0, 1, "Nothing"),
            ("Houston Police Department", "9-1-1", 0, 1, "Nothing")]
    with con:
        cur.executemany("""INSERT INTO important_numbers VALUES (?, ?, ?, ?, ?)""", data)


init_db()
init_tracking()
con.close()