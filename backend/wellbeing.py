import sqlite3 as lite
import config
from flask import Flask, request, g, render_template, jsonify
from flask_socketio import SocketIO
from flask_cas import CAS, login_required

# from flask import session, redirect, url_for, abort, flash, send_from_directory

'''
App Config

'''


app = Flask(__name__)
app.config.from_object("config")
app.config['CAS_SERVER'] = 'https://netid.rice.edu'
app.config['CAS_AFTER_LOGIN'] = 'load_portal'
app.config.setdefault('CAS_USERNAME_SESSION_KEY', 'CAS_USERNAME')
app.config.setdefault('CAS_ATTRIBUTES_SESSION_KEY', 'CAS_ATTRIBUTES')

socketio = SocketIO(app)
CAS(app)

case_id = 0

'''
Database General Operations

'''


def make_dicts(cursor, row):
    return dict((cursor.description[idx][0], value) for idx, value in enumerate(row))


con = lite.connect("wellbeing.db", check_same_thread=False)
con.row_factory = make_dicts
cur = con.cursor()


# get the database
def get_db():
    if not hasattr(g, 'sqlite_db'):
        g.sqlite_db = con
    return g.sqlite_db


# close the database if there is an error
@app.teardown_appcontext
def close_db(error):
    print error
    if hasattr(g, 'sqlite_db'):
        g.sqlite_db.close()


'''
SocketIO Event-Handling

'''


@socketio.on('connect')
def socket_connect():
    print "client connected"


@socketio.on('resolve')
def socket_resolve():
    print "resolving"


'''
Flask Routing

'''


# R.U.P.D. portal
@app.route("/rupd_portal")
@login_required
def load_portal():
    # net_id = session.get(app.config['CAS_USERNAME_SESSION_KEY'], None)
    # attr = session.get(app.config['CAS_ATTRIBUTES_SESSION_KEY'], None)
    # print str(session)
    # print str(request.cookies)

    return render_template('rupd_portal.html')


# Admin page for push requests
@app.route("/admin")
@login_required
def load_admin():

    return render_template('admin.html')


# return a dictionary of numbers and information about wellbeing resources
@app.route("/api/numbers")
def get_numbers():
    return location_get("important_numbers")


@app.route("/api/blue_button_location", methods=['POST', 'GET', 'DELETE'])
def blue_button_location():
    print "hit /api/blue_button_location"
    # Get the location in the database
    if request.method == 'GET':
        # return location_get("tracking_blue_button")
        return get_blue_button_cases()

    # Add location into the database
    if request.method == 'POST':
        return location_post("tracking_blue_button")

    # Delete location according to case id
    if request.method == 'DELETE':
        location_delete("tracking_blue_button")


@app.route("/api/case_id", methods=['GET'])
def get_case_id():
    global case_id
    result = {"result": case_id}
    case_id += 1
    insert_stmt = "INSERT INTO case_id + (id) VALUES (?)"
    cur.execute(insert_stmt, (case_id,))
    return result

'''
Rest API + Database Helpers

'''

# return information from one of the location tables
def location_get(table_name):
    select_stmt = "SELECT * FROM " + table_name
    cur.execute(select_stmt)
    result = {"result": cur.fetchall()}
    return jsonify(result)


# Returns most recent entry for each case in Blue Button table
def get_blue_button_cases():
    table = "tracking_blue_button"
    select_stmt = "SELECT t1.* from " + table + " t1 inner join (select caseID, max(date) as md from " \
                  + table + " group by caseID) t2 on t2.caseID = t1.caseID and t1.date = t2.md"
    cur.execute(select_stmt)
    result = {"result": cur.fetchall()}
    return jsonify(result)


# post information to one of the location tables
def location_post(table_name):
    # construct sqlite query
    f = request.form
    insert_stmt = "INSERT INTO " + table_name + "(caseID, deviceID, longitude, latitude, date, resolved) " \
                                                "VALUES (?, ?, ?, ?, ?, ?)"
    form_values = (f["caseID"], f["deviceID"], f["longitude"],
                   f["latitude"], f["date"], f["resolved"])

    # emit message if blue button
    if table_name == "tracking_blue_button":
        socketio.emit('map message', f)

    with con:
        cur.execute(insert_stmt, form_values)
        con.commit()
        return jsonify({"status": 200})


# delete information from one of the location tables
def location_delete(table_name):
    f = request.form
    with con:
        print f
        cur.execute("DELETE FROM " + table_name + " WHERE caseID=?;""", (f["caseID"],))
        con.commit()
        return jsonify({"status": 200})


def check_case_id():
    global case_id

    if case_id == 0:
        cur.execute("SELECT MAX(id) FROM case_id")
        case_id = cur.fetchall()


if __name__ == "__main__":
    check_case_id()
    socketio.run(app, "0.0.0.0", port=5000)
    # app.run(host="0.0.0.0", debug=True)
