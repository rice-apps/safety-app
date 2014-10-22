import MySQLdb
from flask import Flask, request, session, g, redirect, url_for, abort, render_template, flash, jsonify


app = Flask(__name__)
app.config.from_object(__name__)


#connect to database
def connect_db():
    db = MySQLdb.connect(host="localhost", user="root", passwd='root')
    cursor = db.cursor(MySQLdb.cursors.DictCursor)
    cursor.execute('USE wellbeing')
    return db


def get_db():
    if not hasattr(g, 'my_db'):
        g.my_db = connect_db()
        return g.my_db


# create the database
def init_db():
    with app.app_context():
        db = get_db()

        with app.open_resource('numbers.sql', mode='r') as f:
            db.cursor().execute(f.read())

        db.commit()


@app.teardown_appcontext
def close_db(error):
    if hasattr(g, 'my_db'):
        g.my_db.close()


@app.route("/api/numbers")
def get_numbers():

    db = get_db()
    cursor = db.cursor(MySQLdb.cursors.DictCursor)
    select_statement = "SELECT * FROM important_numbers"
    cursor.execute(select_statement)
    result = {"result": cursor.fetchall()}
    return jsonify(result)

if __name__ == "__main__":
    init_db()
    app.run()