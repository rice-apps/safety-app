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
        print "Hit /api/blue_button_location"
        cur.execute("""SELECT * FROM tracking_escort""")
        result = {"result": cur.fetchall()}
        return jsonify(result)

    success = {"status":200,}
    # Add location into the database
    if request.method == 'POST':
        f = request.form
        insert_stmt = "INSERT INTO tracking_escort (caseID, UUID, longitude, latitude, date, resolved) " \
                      "VALUES (?, ?, ?, ?, ?, ?)"
        form_values = (f["requestID"], f["caseID"], f["longitude"],
                       f["latitude"], f["date"], f["resolved"])
        with con:
            cur.execute(insert_stmt, form_values)
            con.commit()
            return jsonify(success)

    # Delete location according to case id
    if request.method == 'DELETE':
        f = request.form
        with con:
            print f
            cur.execute("""DELETE FROM tracking_escort
                       WHERE caseID=?;""", (f["caseID"], ))
            con.commit()
            return jsonify(success)


@app.route("/api/blue_button_location", methods=['POST', 'GET', 'DELETE'])
def blue_button_location():
    # Get the location in the database
    if request.method == 'GET':
        print "Hit /api/blue_button_location"
        cur.execute("""SELECT * FROM tracking_blue_button""")
        result = {"result": cur.fetchall()}
        return jsonify(result)

    success = {"status": 200, }
    # Add location into the database
    if request.method == 'POST':
        f = request.form
        insert_stmt = "INSERT INTO tracking_blue_button (caseID, UUID, longitude, latitude, date, resolved) " \
                      "VALUES (?, ?, ?, ?, ?, ?)"
        form_values = (f["caseID"], f["UUID"], f["longitude"],
                       f["latitude"], f["date"], f["resolved"])
        with con:
            cur.execute(insert_stmt, form_values)
            con.commit()
            return jsonify(success)

    # Delete location according to case id
    if request.method == 'DELETE':
        f = request.form
        with con:
            cur.execute("""DELETE FROM tracking_blue_button
                       WHERE caseID=?;""", (f["caseID"], ))
            con.commit()
            return jsonify(success)


@app.route("/api/anon_reporting", methods=['POST', 'GET'])
def anon_reporting():
    # Get the reports from the database
    if request.method == 'GET':
        cur.execute("""SELECT * FROM anon_reporting""")
        result = {"result": cur.fetchall()}
        return jsonify(result)

    # Add a report into the database
    if request.method == 'POST':
        print "Hit /api/anon_reporting with a POST!"
        f = request.form
        with con:
            cur.execute("""INSERT INTO anon_reporting (description) VALUES (?)""", (f["description"],))
            con.commit()
        result = {"status": 200, }
        return jsonify(result)


@app.route('/after_login', methods=['GET'])
def after_login():
    net_id = session.get(app.config['CAS_USERNAME_SESSION_KEY'], None)
    return net_id


if __name__ == "__main__":
    app.run()
