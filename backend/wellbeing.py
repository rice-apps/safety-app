import sqlite3 as lite
from flask import Flask, request, session, g, redirect, url_for, abort, render_template, flash, jsonify
from flask_cas import CAS

app = Flask(__name__)
#app.config.from_object('config')
app.config['CAS_SERVER'] = 'https://netid.rice.edu'
app.config['CAS_AFTER_LOGIN'] = 'afterlogin'
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


@app.route("/api/escort_location", methods=['POST', 'GET', 'DELETE'])
def escort_location():
    # Get the location in the database
    if request.method == 'GET':
        print "Hit /api/escort_location"
        cur.execute("""SELECT * FROM tracking_escort""")
        print "escort_location step 2"
        result = {"result": cur.fetchall()}
        return jsonify(result)
    # Add location into the database
    if request.method == 'POST':
        with con:
            if first_time:
                cur.execute("""INSERT INTO tracking VALUES (?, ?, ?, ?)""", (phone_id, longitude_in, latitude_in, time))
            else:
                cur.execute("""UPDATE tracking
                           SET longitude=?, latitude=?
                           WHERE UUID=?;""", (longitude_in, latitude_in, phone_id))
            con.commit()
    # Delete location according to phone id
    if request.method == 'DELETE':
        with con:
            cur.execute("""DELETE FROM tracking
                       WHERE UUID=?;""", (phone_id,))
            con.commit()


@app.route("/api/blue_button_location", methods=['POST', 'GET', 'DELETE'])
def blue_button_location():
    # Get the location in the database
    if request.method == 'GET':
        print "Hit /api/blue_button_location"
        cur.execute("""SELECT * FROM tracking_blue_button""")
        result = {"result": cur.fetchall()}
        return jsonify(result)
    # Add location into the database
    if request.method == 'POST':
        with con:
            if first_time:
                cur.execute("""INSERT INTO tracking VALUES (?, ?, ?, ?)""", (phone_id, longitude_in, latitude_in, time))
            else:
                cur.execute("""UPDATE tracking
                           SET longitude=?, latitude=?
                           WHERE UUID=?;""", (longitude_in, latitude_in, phone_id))
            con.commit()
    # Delete location according to phone id
    if request.method == 'DELETE':
        with con:
            cur.execute("""DELETE FROM tracking
                       WHERE UUID=?;""", (phone_id,))
            con.commit()


@app.route('/after_login', methods=['GET'])
def after_login():
    net_id = session.get(app.config['CAS_USERNAME_SESSION_KEY'], None)
    return net_id


if __name__ == "__main__":
    app.run()
