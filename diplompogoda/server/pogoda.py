from flask import Flask
import requests
app = Flask(__name__)

@app.route("/pogoda/<lat>/<lon>")
def pogoda(lat, lon):
    url = "https://api.weather.yandex.ru/v1/forecast"
    headers = {"X-Yandex-API-Key": "a57bd39d-59d5-47e1-9bfe-00d40e2676c8"}
    data = {"lat": lat, "lon": lon, "lang": "ru_RU"}
    r = requests.get(url, headers=headers, params=data)
    return r.text
