from flask import Flask, render_template, send_from_directory
import requests
import os
app = Flask(__name__)

@app.route("/pogoda/<lat>/<lon>")
def pogoda(lat, lon):
    url = "https://api.weather.yandex.ru/v1/forecast"
    headers = {"X-Yandex-API-Key": "a57bd39d-59d5-47e1-9bfe-00d40e2676c8"}
    data = {"lat": lat, "lon": lon, "lang": "ru_RU"}
    r = requests.get(url, headers=headers, params=data)
    return r.text

@app.route('/')
def root():
    return render_template('yandex.html')

@app.route('/favicon.ico')
def favicon():
    return send_from_directory(os.path.join(app.root_path, 'static'),
                               'favicon.ico', mimetype='image/vnd.microsoft.icon')
