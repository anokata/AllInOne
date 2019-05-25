from flask import Flask, render_template, send_from_directory, request
import requests
import os
import json
from datetime import datetime  
from datetime import timedelta  

app = Flask(__name__)
YANDEX_WHEATHER_APIKEY = "43a9fa46-f747-4526-87ed-518f094abe2b"
CACHE_FILE = "wheather.json"
#"a57bd39d-59d5-47e1-9bfe-00d40e2676c8"
#"73f1e491-d7be-40b2-8f72-d69e4cdf09cd"
# keys:
#fc2d8810-310e-44c7-86ce-1beb9ff466e7
#2d001a12-9851-4254-ae73-b95e65a4170c
# Кеш - {координаты+дата}

def save_json(filename, data):
    try:
        with open(filename, 'w') as fout:
            fout.write(json.dumps(data))
    except:
        pass


def is_old():
    try:
        time = os.path.getmtime(CACHE_FILE)
        expire = datetime.timestamp(datetime.now() - timedelta(hours=1))
        return time < expire
    except:
        return False

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


def get_wheather(lat, lon):
    wheather = load_cache()
    # TODO Если не forrbidden
    # Если нет кеша или он устарел
    if not wheather.get(lat+lon):
        wheather = get_wheather_from_yandex(lat, lon)
        if "Forbidden" not in wheather:
            save_cache(lat, lon, wheather)
    else:
        wheather = wheather[lat+lon]

    return wheather


@app.route("/pogoda/<lat>/<lon>", methods=['GET'])
@app.route("/pogoda/", methods=['POST'])
def pogoda(lat="", lon="", methods=['POST']):
    if request.method == "POST":
        lat = request.form.get("lat")
        lon = request.form.get("lon")
        return get_wheather(lat, lon)
    else:
        return get_wheather(lat, lon)

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
