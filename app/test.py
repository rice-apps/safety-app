from flask import Flask, jsonify

app = Flask(__name__)
@app.route("/")
def a():
    return jsonify({"d": [{"Name": "Night Escort", "Latitude": "29.716752", "Longitude": "-95.401021"}]})

app.run()
