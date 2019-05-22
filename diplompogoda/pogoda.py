from flask import Flask, render_template, send_from_directory
import requests
import os
import json
from datetime import datetime  
from datetime import timedelta  

app = Flask(__name__)
YANDEX_WHEATHER_APIKEY = "73f1e491-d7be-40b2-8f72-d69e4cdf09cd"
CACHE_FILE = "wheather.json"
#"a57bd39d-59d5-47e1-9bfe-00d40e2676c8"
# Кеш - {координаты+дата}

def save_json(filename, data):
    try:
        with open(filename, 'w') as fout:
            fout.write(json.dumps(data))
    except:
        pass


def is_old():
    time = os.path.getmtime(CACHE_FILE)
    expire = datetime.timestamp(datetime.now() - timedelta(hours=1))
    return time < expire

def load_cache():
    wheather = {}

    # Каждый час удалять. Смотрим на дату файла. Если старый удаляем
    if is_old():
        os.remove(CACHE_FILE)
        # TODO запустить поток с обновлением
        return wheather

    try:
        with open(CACHE_FILE, 'r') as fin:
            wheather = json.loads(fin.read())
    except:
        pass
    return wheather

def save_cache(lat, lon, wheather):
    old = load_cache()
    old[lat+lon] = wheather
    save_json(CACHE_FILE, old)

def get_wheather_from_yandex(lat, lon):
    url = "https://api.weather.yandex.ru/v1/forecast"
    headers = {"X-Yandex-API-Key": YANDEX_WHEATHER_APIKEY}
    data = {"lat": lat, "lon": lon, "lang": "ru_RU", "limit": "1"}
    r = requests.get(url, headers=headers, params=data)
    return r.text

# TODO При запросе если кеш старый. пройтись по списку городов и обновить кеш
# дооолго. надо в фоне. потоком.
def refresh_cache():
    if is_old():
        wheather = {}
        with open('static/towns.json') as fin:
            towns = json.loads(fin.read())
            for town in towns:
                lat = town[0]
                lon = town[1]
                data = get_wheather_from_yandex(lat, lon)
                wheather[lat+lon] = data
        save_json(CACHE_FILE, wheather)


@app.route("/pogoda/<lat>/<lon>")
def pogoda(lat, lon):
    wheather = load_cache()
    # Если нет кеша или он устарел
    if not wheather.get(lat+lon):
        wheather = get_wheather_from_yandex(lat, lon)
        save_cache(lat, lon, wheather)
    else:
        wheather = wheather[lat+lon]

    return wheather

@app.route('/')
def root():
    return render_template('yandex.html')

@app.route('/static/<path:path>')
def send_static(path):
    return send_from_directory('static', path)

@app.route('/favicon.ico')
def favicon():
    return send_from_directory(os.path.join(app.root_path, 'static'),
                               'favicon.ico', mimetype='image/vnd.microsoft.icon')
