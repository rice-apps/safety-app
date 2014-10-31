import sqlite3 as lite
import os


def make_dicts(cursor, row):
    return dict((cursor.description[idx][0], value) for idx, value in enumerate(row))

if os.path.exists("wellbeing.db"):
    os.remove("wellbeing.db")

con = lite.connect("wellbeing.db", check_same_thread=False)
con.row_factory = make_dicts
cur = con.cursor()


def init_db():
    with con:
        cur.execute("""DROP TABLE IF EXISTS important_numbers""")
        cur.execute("""CREATE TABLE important_numbers(
                    name TEXT,
                    number TEXT,
                    onCampus INTEGER,
                    allDay INTEGER,
                    description BLOB);""")
        insert_number()
        con.commit()


def insert_number():
    data = [("RUPD/EMS", "(713)348-6000", 1, 1, "Nothing"), ("Student Wellbeing Office", "(713)348-3311", 1, 0,
                                                             "Nothing"),
            ("Student Judicial Programs", "(713)348-4786", 1, 0, "Nothing"), ("Rice Counseling Center", "(713)348-4867",
                                                                              1, 1, "Nothing"),
            ("Student Health Services", "(713)348-4966", 1, 0, "Nothing"), ("Houston Area Women's Center",
                                                                            "(713)528-7273", 0, 1, "Nothing"),
            ("Houston Police Department", "9-1-1", 0, 1, "Nothing")]
    with con:
        cur.executemany("""INSERT INTO important_numbers VALUES (?, ?, ?, ?, ?)""", data)


# def get_info():
#     cur.execute("""SELECT * FROM important_numbers""")
#     info = {"result": cur.fetchall()}
#     return info

init_db()
con.close()