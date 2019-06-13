// Основной код, выполняющиейся после загрузки страницы
window.onload = function () {
    // Вызов главной функции
    init();
};

// Константы
const CITY_DELIMETER = " (";
const WIDTH = 800;
// Время(мс) определния остановки указателя
const MOUSE_PAUSE = 200;
// Величина изменения масштаба за один шаг
const SCALE_VAL = 50;
const ROTATE_EPSILON = 4;
// Максимальная дистанция видимости
const MAX_DISTANCE = 1;
// Минимальный масштаб
const MIN_ZOOM = 300;
// Задержка между кадрами поворота
const ROTATE_TIME = 10;
// Количество кадров при повороте
const ROTATE_STEPS = 14;
// Цвета
const NEAR_CITY_COLOR = '#d33';
const SELECTED_CITY_COLOR = '#3d3';
const WATER_COLOR = "#b1d5e5";
// Цвет пространства вокруг шара
const SPACE_COLOR = "#545859";
const CITY_COLOR = "#333";
const COUNTRY_TEXT_COLOR = "#ffffff";
const RIVER_COLOR = '#0e67a4';
const EDGE_COLOR = '#111';
const FONT_STYLE = "px Arial,Helvetica,sans-serif";
// Словарь аббревиатур стран
const COUNTRY_ABBREV = {
    "Корейская Народно-Демократическая Республика": "КНДР",
    "Республика Корея": "Корея",
    "Демократическая Республика Конго": "Конго",
    "Соединённые Штаты Америки": "США",
    "Южно-Африканская Республика": "ЮАР",
    "Китайская Народная Республика": "КНР",
};
// Глобальные переменные
var width, height;
// Объект проекции
var projection;
// Чувствительность перетаскивания
var sens = 0.25;
// Минимальная дистанция для попадания в город
var city_min_dist = 0.04;
// Цвета стран
var colors = ["#dda6ce", "#aebce1", "#fbbb74", "#b9d888", "#fffac2", "#b4cbb7", "#e4c9ae", "#f7a98e", "#ffe17e"];
// Контекст холста
var context;
// Функция генератора линий
var geoGenerator;
// Объекты карты
var countries, cities, lakes, rivers;
// Таймер мыши для отслеживания остановки указателя
var mouse_timer;
// Таймер всплывающей подсказки для скрытия через N сек
var tooltip_timer; 
// Таймер для поворота к выбранному городу
var rotate_timer;
// Точка мыши
var mouse_point, mouse_xy;
var isDragging = false;
var startingPos = [];
// Ближаший город, выбранный город
var near_city, selected_city;
// Города по уровням
var city_level = {};
// Страны по цветам
var country_by_color = {};
// Словарь городов c координатами
var cities_coords = {};
// Список городов
cities_names = [];
// Список дополнительных городов
cities_names_add = [];
// Таблица кодов стран
countries_codes = {};
// Обратная таблица кодов стран
countries_codes_rev = {};

// Подпрограмма инициализации
function init() {
    // Копирование функции concat из прототипа
    if (!Array.concat) { Array.concat = Array.prototype.concat; }
    // Настойка карты
    setMap();

    // Установка обработчиков кнопок масштабирования
    $("#scaleup").on("click", function() { scale_projection(SCALE_VAL) });
    $("#scaledown").on("click", function() { scale_projection(-SCALE_VAL) });

    // Установка обработчиков масштабирования на колесо мышки
    $("#map").bind('mousewheel DOMMouseScroll', function(event){
        if (event.originalEvent.wheelDelta > 0 || event.originalEvent.detail < 0) {
            // Увеличить масштаб
            scale_projection(SCALE_VAL/2);
        }
        else {
            // Уменьшить масштаб
            scale_projection(-SCALE_VAL/2);
        }
    });
}

// Подпрограмма настройки карты
function setMap() {
    // Высота и ширина карты
    width = WIDTH, height = WIDTH;
     
    // Создание и настройка объекта отрогональной проекции
    projection = d3.geo.orthographic()
        .scale(380)
        .rotate([0, 0])
        .translate([width / 2, height / 2])
        .clipAngle(90);

    // Создание контекста холста для отображения
    context = d3.select('#map canvas')
      .node()
      .getContext('2d', { alpha: false });

    // Настойка холста - задание ширины и высоты
    d3.select('#map canvas')
        .attr('width', width)
        .attr('height', height);

    // Создание функции генератора линий для выбранной проекции
    geoGenerator = d3.geoPath()
      .projection(projection)
      .context(context);

    // Настойка размера точек
    geoGenerator.pointRadius(1.5);

    // Загрузка данных
    loadData();
}

// Подпрограмма загрузки геоданных
function loadData() {
    // Запрос геоданных границ в topoJSON-формате и точек городов
    queue()
      .defer(d3.json, "static/geo/topoworld.json")  
      .defer(d3.json, "static/geo/topolakes.json")  
      .defer(d3.json, "static/geo/toporivers.json")  
      .defer(d3.json, "static/geo/topocitybig.json")  
      .await(processData);  // обработка загруженных данных
}
   
// Подпрограмма обработки загруженных геоданных
function processData(error, worldMap, lakesMap, riversMap, townsMap) {
    if (error) return console.error(error);
    // Извлечение TopoJson данных и сохранение границ стран
    countries = topojson.feature(worldMap, worldMap.objects.world).features;
    // Извлечение TopoJson данных и сохранение озёр
    lakes = topojson.feature(lakesMap, lakesMap.objects.lakes).features;
    // Извлечение TopoJson данных и сохранение рек
    rivers = topojson.feature(riversMap, riversMap.objects.rivers).features;
    // Извлечение TopoJson данных и сохранение городов
    cities = topojson.feature(townsMap, townsMap.objects.citybig).features;

    // Распределение стран в по цвету. В словарь Цвет->список стран. (Для оптимизации отрисовки)
    for (let i = 0; i < countries.length; i++) {
        let country = countries[i];
        // Вычисление индекса цвета
        let color_index = get_color_index(country);
        // Сохранение в массиве стран с таким же цветом
        if (!country_by_color[color_index]) country_by_color[color_index] = [];
        country_by_color[color_index].push(country);
        // Таблица кодов стран и имён
        let cname = country.properties.ADM0_A3;
        countries_codes[cname] = country.properties.NAME_RU;
        countries_codes_rev[country.properties.NAME_RU] = cname;
    }

    // Распределение городов по уровням детализации
    for (let i = 0; i < cities.length; i++) {
        // Извлечение имени города
        let name = cities[i].properties.name_ru;
        if (name) {
            // Вычисление уровня детализации
            let lvl = Math.floor(cities[i].properties.min_zoom*10);
            // Сохранение в массиве городов с таким же уровнем
            if (!city_level[lvl]) city_level[lvl] = [];
            city_level[lvl].push(cities[i]);
            // Заполнение списка имён городов (для поиска)
            let cname = countries_codes[cities[i].properties.ADM0_A3];
            if (cname) {
                cities_names.push(name + CITY_DELIMETER + cname + ")");
            }
            // Заполнение списка городов и их координат
            cities_coords[name] = [cities[i].geometry.coordinates[1], cities[i].geometry.coordinates[0]];
        }
    }

    // Настройка автодополнения имён городов
    autocomplete_init();

    // Отрисовать глобус
    update();

    // Обработчик поворота шара
    d3.selectAll("canvas")
        .call(d3.behavior.drag()
        .origin(function() { var r = projection.rotate(); return {x: r[0] / sens, y: -r[1] / sens}; })
        .on("drag", function() {
            // Возьмём текущие углы поворота
            var rotate = projection.rotate();
            // Изменим поворот на значение зависящее от перемещения мыши
            projection.rotate([d3.event.x * sens, -d3.event.y * sens, rotate[2]]);
            // Обновим карту
            update();
      }));


    // Обработчики событий мыши для различения клика на одном месте и перетаскивания
    $("canvas")
        .mousedown(function (evt) {
            // Сбросим флаг перетаскивания
            isDragging = false;
            // Запомним точку
            startingPos = [evt.pageX, evt.pageY];
        })
        .mousemove(function (evt) {
            // Если точка сменилась - значит перетаскивание
            if (!(evt.pageX === startingPos[0] && evt.pageY === startingPos[1])) {
                isDragging = true;
            }
        });

    // Обработчик нажатия кнопки мыши
    d3.selectAll("canvas")
      .on("mousedown", function() {
          // Запомнить координаты мыши
          mouse_xy = d3.mouse(this);
          // Сбросить таймеры подсказки и поворота
          clearTimeout(tooltip_timer);
          clearTimeout(rotate_timer);
      })
    // Обработчик перемещения мыши
      .on("mousemove", function() {
          // Сбросить таймер остановки мыши
          clearTimeout(mouse_timer);
          // Запуск таймера остановки мыши для вывода краткой сводки погоды в ближайшем городе
          mouse_timer = setTimeout(mouse_stopped, MOUSE_PAUSE);
          // Сохранить точку на которую указывает мышь
          mouse_point = get_mouse_geopoint(this);
          mouse_xy = d3.mouse(this);
          // Скрыть подсказку
          tooltip_hide();
          clearTimeout(tooltip_timer);
      });

    // Обработчик отпускания кнопки мыши
    d3.selectAll("canvas")
      .on("mouseup", function () {
          // В случае если это был клик, а не перетаскивание
          if (!isDragging) {
              // Взять точку на которую указывает мышь
              var mouse_point = get_mouse_geopoint(this);
              // Найти ближайший город
              var nearest = nearest_city(mouse_point);
              // Если точка совпадёт с городом c определённой точностью
              if (nearest) {
                  // Показать погоду в этом городе
                  render_city(nearest);
              } else {
                  // Показать подсказку в этой точке
                  show_weather_data(human_coord(mouse_point), mouse_point[0], mouse_point[1]);
                  // Берём часовой пояс ближайшегого города 
                  var nearest = nearest_city_timezone(mouse_point);
                  var timezone = nearest.properties.TIMEZONE;
                  // Показать погоду по этим координатам
                  render_town(human_coord(mouse_point), mouse_point[0], mouse_point[1], false, undefined, timezone);
              }
          }
          // Сбросим флаг перетаскивания
          isDragging = false;
          startingPos = [];
      });

    // Скрывать подсказку вне карты
    $("body").on("mousemove", function() {
          tooltip_hide();
          clearTimeout(tooltip_timer);
    });

    // Привязка обработчика клика на каждый из дней краткой сводки погоды
    for (let i = 0; i <= 10; i++)
        $("#day_" + i).parent()
            .on("click", function () {
                // Отобразить подробные данные по частям дня
                show_part_weather(i);
				// Установка стиля выбранного дня
				for (let k = 0; k <= 10; k++) {
					$("#day_" + k).parent().removeClass("forecast_focused");
				}
				$("#day_" + i).parent().addClass("forecast_focused");
            });

    render_city(city_by_name("Рыбинск"), false);

    // Привязка обработчиков клика на кнопки переключения подробного прогноза на 5/10 дней
	$("#ten_toggle").on("click", function () {
		$("#ten").css("display", "table-row");
		$("#ten_toggle").addClass("fiveten_selected");
		$("#five_toggle").removeClass("fiveten_selected");
	});
	$("#five_toggle").on("click", function () {
		$("#ten").css("display", "none");
		$("#five_toggle").addClass("fiveten_selected");
		$("#ten_toggle").removeClass("fiveten_selected");
	});
}

// Подпрограмма отрисовки глобуса со всем содержимым
function update() {
    // Очистка холста
    context.fillStyle = SPACE_COLOR;
    context.fillRect(0, 0, width, height);

    // Отображение сфера воды
    context.fillStyle = WATER_COLOR;
    context.beginPath();
    geoGenerator({type: 'Sphere'});
    context.fill();

    // Отображение границ стран
    draw_countries();
    // Отображение линий рек
    draw_rivers();
    // Отображение озёр
    draw_lakes();
    // Отображение названий стран
	draw_country_names();
    // Отображение городов
    draw_cities_by_rank();
    // Отображение ближайшего города
    draw_city(near_city, NEAR_CITY_COLOR);
    // Отображение выбранного города
    draw_city(selected_city, SELECTED_CITY_COLOR);
}

// Подпрограмма отображения погоды города по имени
function render_city(city, is_rotate) {
    // Очистить поле ввода
    $("#cities").val("");
    // Получение страны по городу
    var cname = countries_codes[city.properties.ADM0_A3];
    // Извлечение названия страны
    var name = city.properties.name_ru;
    // Получение временного пояса из данных города
    var timezone = city.properties.TIMEZONE;
    // Если не указан часовой пояс в данных города
    if (!timezone) {
        // Поиск ближайшего города с данными о часовом поясе
        var nearest = nearest_city_timezone([city.geometry.coordinates[0], city.geometry.coordinates[1]]);
        // Взять зону ближайшего города
        timezone = nearest.properties.TIMEZONE;
    }
    // Вызов подпрограммы отображения погоды в выбранном городе
    render_town(name, city.geometry.coordinates[0], city.geometry.coordinates[1], is_rotate, city.properties.name_ru, timezone, cname);
}

// Поиск города по имени
function city_by_name(city_name) {
    // Извлечь название города
    let country_name = "";
    let country_code = "";
    if (city_name.indexOf(CITY_DELIMETER) > 0) {
        country_name = city_name.substr(city_name.indexOf(CITY_DELIMETER) + CITY_DELIMETER.length).replace(")","");
        country_code = countries_codes_rev[country_name];
        city_name = city_name.substr(0, city_name.indexOf(CITY_DELIMETER));
    }
    // Поиск города по имени в списке объектов городов
    for (i = 0; i < cities.length; i++) {
        var city = cities[i];
        if (city.properties.name_ru == city_name) {
            if (country_code && city.properties.ADM0_A3 == country_code)
                // Если нашёлся - возвратить его
                return city;
            if (!country_code) return city;
        }
    }

    // Иначе поиск в списке городов с координатами
    city_data = cities_coords[city_name];
    // Извлечение координат города
    lat = city_data[0];
    lon = city_data[1];
    // Добавление города к общему списку
    return add_selected_city(city_name, lat, lon);
}

// Подпрограмма показывающая данные для выбранного города
function render_town(city, lon, lat, is_rotate, city_name, timezone, cname) {
    // Установка значений параметров по умолчанию
    // Выполнять ли поворот до города
    if (is_rotate == undefined) is_rotate = true;
    // Полное название города
    if (city_name == undefined) city_name = city;

    weather_data = {};
    if (!lon || !lat) { return; }

    // Если поворачивть
    if (is_rotate) {
        // Повернуть до этого города
        rotate_timer = setTimeout(city_rotate, ROTATE_TIME, -lon, -lat);
    }

    // Создаём объект выделенного города
    selected_city = make_feature(city_name, lon, lat);
    near_city = undefined;

    weather_data[city] = {};
    // Добавление в объект погодных данных часового пояса
    weather_data[city]['zone'] = timezone;
    // Добавление в объект погодных данных названия города
	weather_data[city]['cname'] = cname || "";
    // Вызов подпрограммы получения и отображения погодных данных
    send(weather_data, city, lat, lon, view);
    // Отрисовка карты
    update();
}

// Подпрограмма поворота карты до выбранного города
function city_rotate(lon, lat, dn, dt) {
    // Получение текущего значения поворота
    var rotate = projection.rotate();
    var n = rotate[0];
    var t = rotate[1];

    // Вычисление шага смещений по широте и долготе
    if (!dn || !dt) {
        dn = (lon - n) / ROTATE_STEPS;
        dt = (lat - t) / ROTATE_STEPS;
    }
    // Добавление одного смещения
    n += dn;
    t += dt;
    projection.rotate([n, t, rotate[2]]);

    // Отрисовка карты
    update();
    // Если разница между точкой назначения и текущим поворотом больше заданной точности
    if (Math.abs(n - lon) > ROTATE_EPSILON)
        // Сделать ещё один шаг через некоторое время
        rotate_timer = setTimeout(city_rotate, ROTATE_TIME, lon, lat, dn, dt);
}

// Функция создания объекта описывающего город
function make_feature(name, lon ,lat) {
    // Заполнение объекта
    var town = {
        "type":"Feature",
        "properties":{
            "name_ru": name
        },
        "geometry":{
            "type": "Point",
            "coordinates": [lon, lat]
        }
    }
    return town;
}

// Функция добавления выбранного города в список городов
function add_selected_city(city, lat, lon) {
    let city_feature = make_feature(city, lon, lat);
    cities = cities.concat([city_feature]);
    return city_feature;
}

// Подпрограмма изменения масштаба
function scale_projection(value) {
    // Получение текущего значения масштаба
    let scale = projection.scale();
    // Изменение масштаба проекции
    projection.scale(Math.pow(scale, (1 + value/700)));
    // Ограничение минимального масштаба
    if (projection.scale() < MIN_ZOOM) projection.scale(MIN_ZOOM);

    // Отрисовка карты в новом масштабе
    update();

    // Установка размера точек с учётом нового масштаба
    geoGenerator.pointRadius(point_radius(scale));

    // Установка чувствительности перетаскивания с учётом нового масштаба
    if (scale < 500) {
        sens = 0.25;
		city_min_dist = 0.04;
    } else {
        sens = 0.25 - scale/8000;
    }
    if (sens < 0.05) sens = 0.05;
}

// Функция вычисления размер точек для разного масштаба
function point_radius(s) {
    if (s > 1500) return 3;
    if (s < 1000) return 2;
    return s/500
}

// Подпрограмма установки размера шрифта с учётом масштаба
function set_font_size(s) {
    // Получение текущего значение масштаба
    let scale = projection.scale();
    // Вычисление размер шрифта с поправкой на масштаб
    let x = s + Math.pow((scale / 400), 1.07);
	if (scale > 2600) {
		x = s + Math.pow((scale / 400), 0.60);
	}
    // Установка размера шрифта 
    context.font = x + FONT_STYLE;
}

// Подпрограмма отображения границ стран по цветам
function draw_countries() {
    // Настройка цвета и толщины линий
    context.strokeStyle = EDGE_COLOR;
    context.lineWidth = 2.0;
    // Для каждого цвета
    for (let c = 0; c < Object.keys(country_by_color).length; c++) {
        // Выбрать список стран этого цвета
        let countries = country_by_color[c];
            // Установка цвета заливки в текущий цвет стран
            context.fillStyle = colors[c];
            context.beginPath();
            for (let i = 0; i < countries.length; i++) {
                // Отобразить страну
                geoGenerator({type: 'FeatureCollection', features: [countries[i]]})
            }
            // Прочертить границы всех стран
            context.stroke();
            // Залить все страны данного цвета
            context.fill();
    }
}

// Подпрограмма отображения рек
function draw_rivers() {
    // Настройка цвета и толщины линий
    context.strokeStyle = RIVER_COLOR;
    context.lineWidth = 0.5;
    context.beginPath();
    for (var i = 0; i < rivers.length; i++) {
        // Отобразить реку
        geoGenerator({type: 'FeatureCollection', features: [rivers[i]]})
    }
    // Начертить границы
    context.stroke();
}

// Подпрограмма отображения озёр
function draw_lakes() {
    // Настройка цвета и толщины линий
    context.strokeStyle = RIVER_COLOR;
    context.lineWidth = 0.5;
    context.fillStyle = WATER_COLOR;
    context.beginPath();
    for (var i = 0; i < lakes.length; i++) {
        // Отобразить границу озера
        geoGenerator({type: 'FeatureCollection', features: [lakes[i]]})
    }
    // Залить цветом
    context.fill();
    // Начертить границы
	context.stroke();
}

// Подпрограмма отображения города
function draw_city(city, color) {
    if (city) {
        // Настройка цвета и толщины линий
        context.strokeStyle = color;
        context.lineWidth = 5;
        context.beginPath();
        // Отобразить точку города
        geoGenerator({type: 'FeatureCollection', features: [city]})
        // Начертить текст
        context.stroke();
        // Вывести название у города
        show_town_text(city);
    }
}

// Отображение названий стран
function draw_country_names() {
    // Настройка размера шрифта
    set_font_size(13);
    var geojson = countries;
    // Выравнивание текста по центру
    context.textAlign = 'center';
    // Настройка цвета текста
    context.fillStyle = COUNTRY_TEXT_COLOR;
    context.strokeStyle = "#000";
    context.lineWidth = 1.5;
    context.beginPath();
    for (let c = 0; c < Object.keys(country_by_color).length; c++) {
        let countries = country_by_color[c];
        for (let i = 0; i < countries.length; i++) {
            let country = countries[i];
            // Вычисление центральной точки страны
            let geo_center = geoGenerator.centroid(country);
            // Для Франции центр по европейской части без учёта островов
            if (country.properties.ADM0_A3 == "FRA") {
                var obj = {
                    type: "Feature",
                    geometry: {
                        coordinates: [],
                        type: "MultiPolygon"
                    }
                };
                // Извлечение основной части страны
                obj.geometry.coordinates = [country.geometry.coordinates[1]];
                obj.properties = country.properties;
                // Вычисление центральной точки страны
                geo_center = geoGenerator.centroid(obj);
            }
            // Вычисление максимального ранга страны с учётом мастштаба
            let max_zoom = Math.floor(projection.scale() / 120);
            // Если центральная точка страны видима
            if (is_visible_dotp(projection.invert(geo_center))) {
                // И если ранг страны меньше максимального ранга
                if (country.properties.LABELRANK < max_zoom) {
                    // Отобразить текст с названием страны в центральной точке
                    context.strokeText(get_country_name(country), geo_center[0], geo_center[1]); 
                    context.fillText(get_country_name(country), geo_center[0], geo_center[1]); 
                }
            }
        }
	}
    // Начертить весь текст
    context.stroke();
}

// Подпрограмма отображения точек городов
function draw_cities_by_rank() {
    // Настройка размера шрифта
	set_font_size(10);
    context.lineWidth = 0.5;
    context.strokeStyle = CITY_COLOR;
    // Установка цвета заливки
    context.fillStyle = CITY_COLOR;
    context.beginPath();
    // Вычисление максимального уровня города на текущем масштабе
    var max_rank = Math.floor(Math.sqrt(projection.scale()*1.5));
    // Обход городов по уровням
    for (var l = 0; l < max_rank; l++) {
        // Города данного уровня
        var geojson = city_level[l];
        if (geojson)
            // Для каждого города данног уровня
            for (var i = 0; i < geojson.length; i++) {
                var city = geojson[i];
                // Отобразить точку города
                geoGenerator({type: 'FeatureCollection', features: [city]})
                // Вывести название города
                show_town_text(city);
            }
    }
    // Заливка цветом
    context.fill();
}

// Извлечение названия страны с учётом сокращений
function get_country_name(country) {
    // Получение названия страны
    let name = country.properties.NAME_RU;
    // Если имеется аббревиатура для неё
    if (Object.keys(COUNTRY_ABBREV).indexOf(name) >= 0) {
        name = COUNTRY_ABBREV[name];
    }
    return name;
}

// Вывод названия у города
function show_town_text(town) {
    // Если данный город виден при текущем повороте глобуса
    if (is_visible_dotp(town.geometry.coordinates)) {
        // Получим экранные координаты точки спроецировав координаты города
        var xy = projection(town.geometry.coordinates);
        // Вывод текста с именем города в полученных координатах
        context.fillText(town.properties.name_ru || "", xy[0], xy[1] - 5); 
    }
}

// Функция определения видимости точки на глобусе по отдельным координатам
function is_visible_dot(lat, lon) {
    var rlon = projection.rotate()[0];
    var rlat = projection.rotate()[1];
    // Вычисление расстояни между точками и сравнение с максимально допустимой дистанцией
    return d3.geoDistance([lon, lat], [-rlon, -rlat]) < MAX_DISTANCE;
}

// Функция определения видимости точки на глобусе
function is_visible_dotp(geopoint) {
    // Получение координат поворота
    var rlon = projection.rotate()[0];
    var rlat = projection.rotate()[1];
    // Извлечение координат
    var lon = geopoint[0];
    var lat = geopoint[1];
    // Вычисление расстояни между точками и сравнение с максимально допустимой дистанцией
    return d3.geoDistance([lon, lat], [-rlon, -rlat]) < MAX_DISTANCE;
}

// Функция вычисления индекса цвета в списке цветов colors
function get_color_index(d) { 
    var c = d.properties.MAPCOLOR9 || 0;
    var n = Math.abs(c % colors.length);
    return n; 
}

// Функция вычисления цвета страны
function get_color(d) { 
    return colors[get_color_index(d)]; 
}

// Подпрограмма форматирования координат
function human_coord(p) {
    // Широта latitude сев/юж  Долгота longitude вост/зап
    // Например 55°45′21″ с. ш. 37°37′04″ в. д.
    // Извлечение значений долготы и широты
    var lon = p[0];
    var lat = p[1];
	if (!lon || !lat) return null;
    var coord_text = "";

    // Формирование текста для широты
    coord_text += Math.abs(Math.floor(lat));
    if (lat > 0) {
        coord_text += "° c.ш. ";
    } else {
        coord_text += "° ю.ш. ";
    }

    // Формирование текста для долготы
    coord_text += Math.abs(Math.floor(lon));
    if (lon > 0) {
        coord_text += "° в.д.";
    } else {
        coord_text += "° з.д.";
    }
    return coord_text;
}
   
// Функция извлечения координат указателся мыши
function get_mouse_geopoint(self) {
          var lon, lat;
          lon = projection.invert(d3.mouse(self))[0];
          lat = projection.invert(d3.mouse(self))[1];
          return [lon, lat];
}

// Подпрограмма поиска ближайшего города
function nearest_city(p) {
    // Вычислим расстояние между точкой мыши и каждым городом
    var nearest;
    var min_distance = 10000000;

    // Вычисление максимального ранга города с учётом масштаба
    var max_rank = Math.floor(projection.scale() / 14);
    // Перебор городов по рангу
    for (var l = 0; l < max_rank; l++) {
        var cities = city_level[l];
    if (cities)
    for (i = 0; i < cities.length; i++) {
        var city = cities[i];
        var city_point = [city.geometry.coordinates[0], city.geometry.coordinates[1]]
        var dist = d3.geo.distance(p, city_point);
        if (min_distance > dist) {
            min_distance = dist;
            nearest = city;
        }
    }
    }
    if (min_distance < city_min_dist) {
        return nearest;
    } else return false;
}

// Функция поиска ближайшего города с часовым поясом
function nearest_city_timezone(p) {
    var nearest;
    var min_distance = 10000000;

    for (i = 0; i < cities.length; i++) {
        // Берём координаты очередного города
        var city = cities[i];
        var city_point = [city.geometry.coordinates[0], city.geometry.coordinates[1]]
        // Вычислим дистанцию между городом и точкой указателя
        var dist = d3.geo.distance(p, city_point);
        // В случае если этот город ближе и имеет данные о часовом поясе - запомним его
        if (min_distance > dist && city.properties.TIMEZONE) {
            min_distance = dist;
            nearest = city;
        }
    }
    // Возвращение самого ближайшего подходящего города
    return nearest;
}

// Подпрограмма обработки остановки указателя
function mouse_stopped() {
    // Поиск ближайшего города
    var nearest = nearest_city(mouse_point);
    // Если есть рядом город
    if (nearest) {
        near_city = nearest;
        // Отрисовка карты
        update();
        // Отобразить погодные данные по ближайшему городу в подсказке
        make_weather_text(nearest);
    }
}

// Подпрограмма отображения погоды города
function make_weather_text(city) {
    // Извлечение координат и имени города
    var lon = city.geometry.coordinates[0]; 
    var lat = city.geometry.coordinates[1];
    var city_name = city.properties.name_ru;
    // Вызов подпрограммы отображения погдных данных
    show_weather_data(city_name, lon, lat);
}

// Подпрограмма формирования всплывающей подсказки
function show_weather_data(city_name, lon, lat) {
	if (!city_name) return;
    // Формирование текста с данными
    var weather_data = {};
    // Получение погодных данных в выбранной точке
    send(weather_data, city_name, lat, lon, function (weather_data) {
          // Обработка погодных данных и формирование текста для сводки
          weather_data["city"] = city_name;
          // Формирование текста с погодной сводкой
        
          $("#tooltip_cityname").text(city_name);
          $("#tooltip_icon img").attr("src", make_icon(weather_data[city_name]["icon"]));
          $("#tooltip_condition").text(human_condition(weather_data[city_name]["condition"]));
          $("#tooltip_temp").text(human_temp_grad(weather_data[city_name]["temp"]));
          $("#tooltip_hum").text(weather_data[city_name]["humidity"] + "%");
          $("#tooltip_wind").text(human_wind(weather_data[city_name]["wind_dir"], weather_data[city_name]["wind_speed"]));

          $("#tooltip")
              .css("left", (mouse_xy[0] + 33) + "px")
              .css("top", (mouse_xy[1] + 47) + "px")
              .css("display", "block");

          tooltip_timer = setTimeout(tooltip_hide, 5000);
    });
}

// Обработчик скрытия подсказки
function tooltip_hide(){
    $("#tooltip")
        .css("display", "none");
}

// конфигурации поля ввода городов с автодополнением
function autocomplete_init() {
    // При выборе города из подсказки
    $("#cities").autocomplete({
          source: cities_names,
          minLength: 3,
          select: function(event, ui) {
            // Отобразить погоду по городу
            render_city(city_by_name(ui.item.value));
          }
    });
    // При нажатии Enter
    $("#cities").keypress(function(e){
        if(e.keyCode==13) {
            var city = upper_first($("#cities").val());
            // Подставить имя города в поле ввода
            $("#cities").val(city);
            // Отобразить погоду по городу
            render_city(city_by_name(city));
        }
    });
    $('button').on("click", function() {
            var city = upper_first($("#cities").val());
            render_city(city_by_name(city));
    });
}


