import sqlite3 as lite
import os
from flask import Flask, request, session, g, redirect, url_for, abort, render_template, flash, jsonify, send_from_directory
from flask_cas import CAS
from flask_mail import Mail
from flask_mail import Message
import config

app = Flask(__name__)
# app.config.from_object('config')
app.config['CAS_SERVER'] = 'https://netid.rice.edu'
app.config['CAS_AFTER_LOGIN'] = 'afterlogin'
app.config['APP_URL'] = 'localhost:5000'
app.config.setdefault('CAS_USERNAME_SESSION_KEY', 'CAS_USERNAME')
CAS(app)

# Email setup
app.config['MAIL_SERVER'] = 'smtp.zoho.com'
app.config['MAIL_PORT'] = 465
app.config['MAIL_USERNAME'] = config.MAIL_USERNAME
app.config['MAIL_PASSWORD'] = config.MAIL_PASSWORD
app.config['MAIL_USE_TLS'] = False
app.config['MAIL_USE_SSL'] = True
app.config['MAIL_SUPPRESS_SEND'] = False
app.config['TESTING'] = False
mail = Mail(app)


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
    if hasattr(g, 'sqlite_db'):
        g.sqlite_db.close()


# return a dictionary of numbers and information about wellbeing resources
@app.route("/api/numbers")
def get_numbers():
    return location_get("important_numbers")


@app.route("/api/escort_location", methods=['POST', 'GET', 'DELETE'])
def escort_location():
    print "hit /api/escort_location"
    # Get the location in the database
    if request.method == 'GET':
        return location_get("tracking_escort")

    # Add location into the database
    if request.method == 'POST':
        return location_post("tracking_escort")

    # Delete location according to case id
    if request.method == 'DELETE':
        location_delete("tracking_escort")


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


@app.route("/test_push", methods=['POST', 'GET'])
def test_push():
    if request.method == 'GET':
        print ("hit /test_push with get")
        return render_template("rupd_portal.html")
    if request.method == 'POST':
        print ("hit /test_push with POST")
        f = request.form
        longitude = f["longitude"]
        latitude = f["latitude"]
        print ("lat: " + latitude, ", long: " + longitude)
        return jsonify({"lat": latitude, "long": longitude})



@app.route("/api/anon_reporting", methods=['POST', 'GET'])
def anon_reporting():
    print "hit /api/anon_reporting"
    # Get the reports from the database
    if request.method == 'GET':
        return location_get("anon_reporting")

    # Add a report into the database
    if request.method == 'POST':
        print "email initiated"
        f = request.form

        # Send an email report to RUPD
        # TODO: switch the recipient email to config.RUPD_EMAIL
        msg = Message("Anonymous RUPD Report", sender=app.config['MAIL_USERNAME'], recipients=['agl5@rice.edu'])
        msg.body = format_email(f["description"])  # TODO: write the actual email message
        mail.send(msg)
        print "mail sent"

        with con:
            print "inserting to db"
            cur.execute("""INSERT INTO anon_reporting (description) VALUES (?)""", (f["description"],))
            con.commit()
        result = {"status": 200}
        return jsonify(result)


@app.route('/after_login', methods=['GET'])
def after_login():
    net_id = session.get(app.config['CAS_USERNAME_SESSION_KEY'], None)
    return net_id


@app.route('/is_authorized', methods=['POST'])
def is_authorized():
    f = request.form
    if f["password"] == config.RUPD_PASSWORD:
        result = {"authorized": 1}
    else:
        result = {"authorized": 0}
    return jsonify(result)


# return information from one of the location tables
def location_get(table_name):
    select_stmt = "SELECT * FROM " + table_name
    cur.execute(select_stmt)
    result = {"result": cur.fetchall()}
    return jsonify(result)


# Returns most recent entry for each case in Blue Button table
def get_blue_button_cases():
    table = "tracking_blue_button"
    select_stmt = "SELECT t1.* from " + table + " t1 inner join (select caseID, max(date) as md from " + table + " group by caseID) t2 on t2.caseID = t1.caseID and t1.date = t2.md"
    cur.execute(select_stmt)
    result = {"result": cur.fetchall()}
    return jsonify(result)


# post information to one of the location tables
def location_post(table_name):
    f = request.form
    insert_stmt = "INSERT INTO " + table_name + "(caseID, deviceID, longitude, latitude, date, resolved) " \
                                                "VALUES (?, ?, ?, ?, ?, ?)"
    print f["caseID"]
    print f["deviceID"]
    form_values = (f["caseID"], f["deviceID"], f["longitude"],
                   f["latitude"], f["date"], f["resolved"])
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


# TODO: Format the message into a more presentable format
def format_email(message):
    return message


if __name__ == "__main__":
    app.run(host="0.0.0.0", debug=True)
