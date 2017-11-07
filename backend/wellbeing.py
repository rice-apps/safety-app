import sqlite3 as lite
from flask import Flask, request, g, render_template, jsonify
from flask_socketio import SocketIO
from flask_cas import CAS, login_required
# from flask import session, redirect, url_for, abort, flash, send_from_directory


'''
App Config

'''


app = Flask(__name__)
# app.config.from_object("config")
app.config['CAS_SERVER'] = 'https://netid.rice.edu'
app.config['CAS_AFTER_LOGIN'] = 'load_portal'
app.config.setdefault('CAS_USERNAME_SESSION_KEY', 'CAS_USERNAME')
app.config.setdefault('CAS_ATTRIBUTES_SESSION_KEY', 'CAS_ATTRIBUTES')

socketio = SocketIO(app)
CAS(app)


'''
Database General Operations

'''


def make_dicts(cursor, row):
    return dict((cursor.description[idx][0], value) for idx, value in enumerate(row))


def connect_db():
    """
    Connects to the database.
    
    Returns: Database connection object.

    """
    con = lite.connect("wellbeing.db", check_same_thread=False)
    con.row_factory = make_dicts
    return con


# get the database
def get_db():
    """
    Get the database from flask, and connect if nonexistant.
    
    Returns: Flask database object.

    """
    if not hasattr(g, 'sqlite_db'):
        g.sqlite_db = connect_db()
    return g.sqlite_db


@app.teardown_appcontext
def close_db(error):
    """
    Closes the database if there is an error.

    Args:
        error: Error causing shutdown.

    Returns: None.

    """
    print error
    if hasattr(g, 'sqlite_db'):
        g.sqlite_db.close()


'''
SocketIO Event-Handling

'''


@socketio.on('connect')
def socket_connect():
    """
    Handler to notify server that a client has connected.
    
    Returns: None.

    """
    print "SocketIO: Client connected."


'''
Flask Routing

'''


@app.route("/rupd_portal")
@login_required
def load_portal():
    """
    Load RUPD portal template.
    
    Returns: None.

    """
    # net_id = session.get(app.config['CAS_USERNAME_SESSION_KEY'], None)
    # attr = session.get(app.config['CAS_ATTRIBUTES_SESSION_KEY'], None)
    # print str(session)
    # print str(request.cookies)

    return render_template('rupd_portal.html')


@app.route("/api/numbers", methods=['GET'])
def get_numbers():
    """
    Route of get request for table |important_numbers|.
    
    Returns: Dictionary of numbers and information about well-being resources.

    """
    return location_get("important_numbers")


@app.route("/api/blue_button_location", methods=['POST', 'GET', 'DELETE'])
def blue_button_location():
    """
    Route of requests for emergency case information.
     
    Returns:
        - 'GET': dictionary of case information
        - 'POST': status of emergency case post request
        - 'DELETE': status of emergency case delete request

    """
    # Get the location in the database
    if request.method == 'GET':
        return get_blue_button_cases()

    # Add location into the database
    if request.method == 'POST':
        return location_post("tracking_blue_button")

    # Delete location according to case id
    if request.method == 'DELETE':
        return location_delete("tracking_blue_button")


@app.route("/api/case_id", methods=['GET'])
def get_case_id():
    """
    Route of request for a case ID. Increments case ID after response.
    
    Returns: The next case ID.

    """
    db = get_db()
    # get next id from db
    cur = db.execute("SELECT MAX(id) FROM case_id")
    case_id = dict(cur.fetchone())["MAX(id)"]
    # return it
    result = {"result": case_id}
    # add new next id to db
    insert_stmt = "INSERT INTO case_id (id) VALUES (?)"
    next_case = case_id + 1
    with db:
        db.execute(insert_stmt, (next_case,))
        db.commit()
        return jsonify(result)


@app.route("/api/log", methods=['GET'])
def get_log():
    db = get_db()
    # get all data from database


'''
Rest API + Database Helpers

'''


def location_get(table_name):
    """
    Gets data from table.
    
    Args:
        table_name: Name of table in DB.

    Returns: All data in table |table_name|.

    """
    db = get_db()
    select_stmt = "SELECT * FROM " + table_name
    cur = db.execute(select_stmt)
    result = {"result": cur.fetchall()}
    print result
    print jsonify(result)
    return jsonify(result)


def get_blue_button_cases():
    """
    Gets most recent entry for each active case.
    
    Returns: Most recent entry for each active case.

    """
    db = get_db()
    table = "tracking_blue_button"
    select_stmt = "SELECT t1.* from " + table + " t1 inner join (select caseID, max(date) as md from " \
                  + table + " group by caseID) t2 on t2.caseID = t1.caseID and t1.date = t2.md"
    cur = db.execute(select_stmt)
    result = {"result": cur.fetchall()}
    return jsonify(result)


def location_post(table_name):
    """
    Posts information to table |table_name|.
    
    Args:
        table_name: Name of table in DB.

    Returns: Post status.

    """
    # construct sqlite query
    f = request.form
    insert_stmt = "INSERT INTO " + table_name + "(caseID, deviceID, longitude, latitude, date, resolved) " \
                                                "VALUES (?, ?, ?, ?, ?, ?)"
    form_values = (f["caseID"], f["deviceID"], f["longitude"],
                   f["latitude"], f["timestamp"], f["resolved"])

    # emit message if blue button
    if table_name == "tracking_blue_button":
        socketio.emit('map message', f)

    db = get_db()

    with db:
        db.execute(insert_stmt, form_values)
        db.commit()
        return jsonify({"status": 200})


def location_delete(table_name):
    """
    Deletes a case from table |table_name|.
    
    Args:
        table_name: Name of table in DB.

    Returns: Delete status.

    """
    db = get_db()
    f = request.form
    with db:
        print f
        db.execute("DELETE FROM " + table_name + " WHERE caseID=?;""", (f["caseID"],))
        db.commit()
        return jsonify({"status": 200})


'''
Main Function

'''


if __name__ == "__main__":
    # Start SocketIO
    socketio.run(app, "0.0.0.0", port=5000)
    # app.run(host="0.0.0.0", debug=True)
