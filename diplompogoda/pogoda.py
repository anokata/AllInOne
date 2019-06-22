from flask import Flask, render_template, send_from_directory, request
import requests
import os
import json
from datetime import datetime  
from datetime import timedelta  

# Создание объекта приложения
app = Flask(__name__)
# API-ключ к сервису Яндекс.Погоды
#YANDEX_WHEATHER_APIKEY = "43a9fa46-f747-4526-87ed-518f094abe2b"
#YANDEX_WHEATHER_APIKEY = "2d001a12-9851-4254-ae73-b95e65a4170c"
YANDEX_WHEATHER_APIKEY = "f5179842-5f92-4942-ad9e-169ec224452c"
# keys:
#1553bb9f-a1a2-40d3-8662-1c7d53c994f1
#fc2d8810-310e-44c7-86ce-1beb9ff466e7
#2d001a12-9851-4254-ae73-b95e65a4170c
# URL адрес API Яндекс.Погоды
YANDEX_WHEATHER_URL = "https://api.weather.yandex.ru/v1/forecast"
# Имя кеш файла
CACHE_FILE = "weather.json"
# Кеш = словарь, ключ=координаты, значение=погодные данные по этим координатам
# Флаг использования только кеша (для отладки)
CACHE_ONLY = False
#"a57bd39d-59d5-47e1-9bfe-00d40e2676c8"
#"73f1e491-d7be-40b2-8f72-d69e4cdf09cd"

# Обработчик запроса погодных данных
@app.route("/pogoda/<lat>/<lon>", methods=['GET'])
@app.route("/pogoda/", methods=['POST'])
def pogoda(lat="", lon="", methods=['POST']):
    # Получение широты и долготы из параметров формы POST запроса
    if request.method == "POST":
        lat = request.form.get("lat")
        lon = request.form.get("lon")
        # Получение погодных данных для данной точки и возвращение их как результата
        return get_weather(lat, lon)
    else:
        return get_weather(lat, lon)

# Обработчик запроса к главной странице
@app.route('/')
def root():
    # Вернуть html страницу
    return render_template('main.html')

# Обработчик запросов к статичным ресурсам
@app.route('/static/<path:path>')
def send_static(path):
    # Вернуть запрошенный файл
    return send_from_directory('static', path)

# Обработчик иконки сайта
@app.route('/favicon.ico')
def favicon():
    return send_from_directory(os.path.join(app.root_path, 'static'),
                               'favicon.ico', mimetype='image/vnd.microsoft.icon')

# Функция получения погодных данных, из кеша или свежих
def get_weather(lat, lon):
    weather = load_cache()
    # Если нет кеша или он устарел
    if not weather.get(lat+lon):
        # Получение свежих данных
        weather = get_weather_from_yandex(lat, lon)
        # Если данные успешно получены
        if "Forbidden" not in weather:
            # Сохранение в кеш новых данных
            save_cache(lat, lon, weather)
    else:
        # Иначе взять из кеша
        weather = weather[lat+lon]

    # Вернуть погодные данные
    return weather

# Функция загрузки погодных данных по геоточке через сервис Яндекс.Погоды
def get_weather_from_yandex(lat, lon):
    # Подготовка заголовков запроса - API-ключ
    headers = {"X-Yandex-API-Key": YANDEX_WHEATHER_APIKEY}
    # Подготовка параметров запроса - широта, долгота, язык
    data = {"lat": lat, "lon": lon, "lang": "ru_RU", "limit": "1"}
    # Выполнение запроса к API Яндекс.Погоды
    r = requests.get(YANDEX_WHEATHER_URL, headers=headers, params=data)
    # Возвратить результат запроса
    return r.text

# Подпрограмма сохранения json данных в файл
def save_json(filename, data):
    try:
        with open(filename, 'w') as fout:
            fout.write(json.dumps(data))
    except:
        pass

# Подпрограмма определяющая устаревание файла кеша на 1 час
def is_old():
    try:
        # Получение времени кэша
        try:
            # Чтение данных из кеша
            with open(CACHE_FILE, 'r') as fin:
                c = json.loads(fin.read())
                time = float(c['timestamp'])
        except:
            return False
        # Вычисление срока устаревания
        expire = datetime.timestamp(datetime.now() - timedelta(hours=1))
        print("Delete cache" if time < expire else "Actual cache")
        # Если файл старее срока устаревания -> устарел
        return time < expire
    except:
        return False

# Функция загрузки данных из кеша
def load_cache():
    ts = datetime.now().timestamp()
    weather = {'timestamp': str(ts)}

    # Каждый час удалять. Если старый удаляем
    if is_old() and not CACHE_ONLY:
        # Удаление файла кеша
        os.remove(CACHE_FILE)
        # Записать новую дату
        save_cache(str(ts), "", ts)
        return weather

    try:
        # Чтение данных из кеша
        with open(CACHE_FILE, 'r') as fin:
            weather = json.loads(fin.read())
    except:
        pass
    return weather

# Подпрограмма записи новых данных в кеш
def save_cache(lat, lon, weather):
    # Загрузка кеша
    old = load_cache()
    # Добавление данных
    old[lat+lon] = weather
    # Запись обновлённых данных в кеш
    save_json(CACHE_FILE, old)


if __name__ == '__main__':
    app.run()
