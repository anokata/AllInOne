from flask import Flask, render_template, send_from_directory
import requests
import os
import json
app = Flask(__name__)
YANDEX_WHEATHER_APIKEY = "73f1e491-d7be-40b2-8f72-d69e4cdf09cd"
CACHE_FILE = "wheather.json"
#"a57bd39d-59d5-47e1-9bfe-00d40e2676c8"
# Кеш - {координаты+дата}

# Каждый час удалять. Смотрим на дату файла. Если старый удаляем
def load_cache():
    wheather = {}
    try:
        with open(CACHE_FILE, 'r') as fin:
            wheather = json.loads(fin.read())
    except:
        pass
    return wheather

def save_cache(lat, lon, wheather):
    old = load_cache()
    old[lat+lon] = wheather
    try:
        with open(CACHE_FILE, 'w') as fout:
            fout.write(json.dumps(old))
    except:
        pass

# test
#load_cache()

def get_wheather_from_yandex(lat, lon):
    url = "https://api.weather.yandex.ru/v1/forecast"
    headers = {"X-Yandex-API-Key": YANDEX_WHEATHER_APIKEY}
    data = {"lat": lat, "lon": lon, "lang": "ru_RU", "limit": "1"}
    r = requests.get(url, headers=headers, params=data)
    return r.text

@app.route("/pogoda/<lat>/<lon>")
def pogoda(lat, lon):
    wheather = load_cache()
    if not wheather.get(lat+lon):
        # Если нет кеша или он устарел
        wheather = get_wheather_from_yandex(lat, lon)
        save_cache(lat, lon, wheather)
    else:
        wheather = wheather[lat+lon]

    return wheather

# TODO При запросе если кеш старый. пройтись по списку городов и обновить кеш
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
