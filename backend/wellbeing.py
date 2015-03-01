import sqlite3 as lite
import uuid
from flask import Flask, request, session, g, redirect, url_for, abort, render_template, flash, jsonify
from flask_cas import CAS

app = Flask(__name__)
app.config.from_object('config')
app.config['CAS_SERVER'] = 'https://netid.rice.edu'
app.config['CAS_AFTER_LOGIN'] = 'after_login'
app.config['APP_URL'] = 'localhost:5000'
app.config.setdefault('CAS_USERNAME_SESSION_KEY', 'CAS_USERNAME')
CAS(app)


def make_dicts(cursor, row):
    return dict((cursor.description[idx][0], value) for idx, value in enumerate(row))

con = lite.connect("wellbeing.db", check_same_thread=False)
con.row_factory = make_dicts
cur = con.cursor()


#get the database
def get_db():
    if not hasattr(g, 'sqlite_db'):
        g.sqlite_db = con
    return g.sqlite_db


#close the database if there is an error
@app.teardown_appcontext
def close_db(error):
    if hasattr(g, 'sqlite_db'):
        g.sqlite_db.close()


#return a dictionary of numbers and information about wellbeing resources
@app.route("/api/numbers")
def get_numbers():
    cur.execute("""SELECT * FROM important_numbers""")
    result = {"result": cur.fetchall()}
    return jsonify(result)


def add_location(first_time, id, longitude_in, latitude_in, time):
    with con:
        if first_time:
            cur.execute("""INSERT INTO tracking VALUES (?, ?, ?, ?)""", (id, longitude_in, latitude_in, time))
        else:
            cur.execute("""UPDATE tracking
                           SET longitude=?, latitude=?
                           WHERE UUID=?;""", (longitude_in, latitude_in, id))
        con.commit()

@app.route("/api/location")
def get_location():
    cur.execute("""SELECT * FROM tracking""")
    result = {"result": cur.fetchall()}
    return jsonify(result)


@app.route('/after_login', methods=['GET'])
def after_login():
    net_id = session.get(app.config['CAS_USERNAME_SESSION_KEY'], None)
    return redirect('/api/numbers')


@app.route("/api/del_location")
def delete_location(id):
    with con:
        cur.execute("""DELETE FROM tracking
                       WHERE UUID=?;""", (id,))
        con.commit()


if __name__ == "__main__":

    app.run()