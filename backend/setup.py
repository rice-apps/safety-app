import sqlite3 as lite
import json
import os
from wellbeing import app


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
        with app.open_resource('numbers.sql', mode='r') as f:
            cur.executescript(f.read())
        with app.open_resource('tracking.sql', mode='r') as f:
            cur.executescript(f.read())
        insert_number()
        con.commit()


#insert the numbers of wellbeing resources into the database
def insert_number():
    data = []
    numbers = json.load(open('numbers_data.json'))['data']
    for n in numbers:
        data.append((n['name'], n['number'], n['onCampus'], n['allDay'], n['description']))
    with con:
        cur.executemany("""INSERT INTO important_numbers VALUES (?, ?, ?, ?, ?)""", data)


init_db()
con.close()