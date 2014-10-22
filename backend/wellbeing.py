import MySQLdb
from flask import Flask, request, session, g, redirect, url_for, abort, render_template, flash, jsonify


app = Flask(__name__)
app.config.from_object(__name__)

#connect to database
db = MySQLdb.connect("localhost", "root", "root", "wellbeing")
cursor = db.cursor(MySQLdb.cursors.DictCursor)


# create the database
def init_db():
    with app.app_context():
        with app.open_resource('wellbeing_schema.sql', mode='r') as f:
            cursor.execute(f.read())
        db.commit()


@app.teardown_appcontext
def close_db(error):
    if hasattr(g, 'my_db'):
        g.my_db.close()

@app.route("/api/numbers")
def get_numbers():
    select_statement = """SELECT * FROM important_numbers"""
    cursor.execute(select_statement)
    result = {"result": cursor.fetchall()}
    return jsonify(result)

if __name__ == "__main__":
    init_db()
    app.run()

