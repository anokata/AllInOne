// Основной код, выполняющиейся после загрузки страницы
window.onload = function () {
// Константы
const WIDTH = 800;
const MOUSE_PAUSE = 200;
const SCALE_VAL = 50;
const ROTATE_EPSILON = 5;
const ROTATE_STEPS = 12;
const MAX_DISTANCE = 1;
const MIN_ZOOM = 300;
const ROTATE_TIME = 10;
// Цвета
const NEAR_CITY_COLOR = '#d33';
const SELECTED_CITY_COLOR = '#3d3';
const WATER_COLOR = "#b1d5e5";
const SPACE_COLOR = "#7397a4";
const CITY_COLOR = "#333";
const COUNTRY_TEXT_COLOR = "#333";
const RIVER_COLOR = '#0e67a4';
const EDGE_COLOR = '#111';
const COUNTRY_ABBREV = {
    "Корейская Народно-Демократическая Республика": "КНДР",
    "Республика Корея": "Корея",
    "Демократическая Республика Конго": "Конго",
    "Соединённые Штаты Америки": "США",
    "Южно-Африканская Республика": "ЮАР",
    "Китайская Народная Республика": "КНР",
};
var width, height, projection;
var sens = 0.25;
var city_min_dist = 0.04;
var colors = ["#dda6ce", "#aebce1", "#fbbb74", "#b9d888", "#fffac2", "#b4cbb7", "#e4c9ae", "#f7a98e", "#ffe17e"];
// Элемент всплывающей подсказки
var tooltip = d3.select("body").append("div").attr("class", "tooltip");
var context, geoGenerator;
var world, cities, lakes, rivers;
// Таймер мыши для отслеживания остановки указателя
var mouse_timer;
// Таймер всплывающей подсказки для скрытия через N сек
var tooltip_timer; 
// Таймер для поворота к выбранному городу
var rotate_timer;
var mouse_point, mouse_xy;
var isDragging = false;
var startingPos = [];
var near_city, selected_city;
var city_level = {};
var country_by_color = {};

function render_city(city, is_rotate) {
    // Поиск страны по городу
    var country_name = country_for_city(city);
    var name = city.properties.name_ru;
	var cname = "";
    if (country_name) {
        cname = country_name.properties.NAME_RU;
    }
    var timezone = city.properties.TIMEZONE;
    // Если null то взять зону ближайшего города
    if (!timezone) {
        var nearest = nearest_city_timezone([city.geometry.coordinates[0], city.geometry.coordinates[1]]);
        timezone = nearest.properties.TIMEZONE;
    }
    //console.log("T1", city, timezone);
    render_town(name, city.geometry.coordinates[0], city.geometry.coordinates[1], is_rotate, city.properties.name_ru, timezone, cname);
}

function country_for_city(city) {
    var country_name_eng = city.properties.ADM0NAME;
    //console.log(country_name_eng);
    for (let i = 0; i < world.features.length; i++) {
        var country = world.features[i];
        //console.log(country.NAME);
        if (country.properties.NAME == country_name_eng) {
            //console.log(country);
            return country;
        }
    }
}

// Поиск города по имени
function city_by_name(city_name) {
    for (i = 0; i < cities.length; i++) {
        var city = cities[i];
        if (city.properties.name_ru == city_name) {
            //console.log(city);
            return city;
        }
    }

    // TODO Если и тут нет
    city_data = cities_coords[city_name];
    lat = city_data[0];
    lon = city_data[1];
    // TODO если нет но есть в допе
    return add_selected_city(city_name, lat, lon);
}

// Подпрограмма показывающая данные для выбранного города
function render_town(city, lon, lat, is_rotate, city_name, timezone, cname) {
    if (is_rotate == undefined) is_rotate = true;
    if (city_name == undefined) city_name = city;

    wheather_data = {}; // Global
    // TODO DEL?
    if (!lon || !lat) {
        //console.log("DLE");
        //city_data = cities_coords[city];
        //lat = city_data[0];
        //lon = city_data[1];
		return;
    }
    if (is_rotate) {
        // Повернуть до этого города
        rotate_timer = setTimeout(city_rotate, ROTATE_TIME, -lon, -lat);
    }

    selected_city = make_feature(city_name, lon, lat);
    near_city = undefined;

    if (timezone == undefined) {
        // TODO найти ближайшую по координатам
        timezone = "";
    }
            
    //console.log(city, lon, lat, city_name);
    //TODO moment.js timezone to wheather_data
    wheather_data[city] = {};
    wheather_data[city]['zone'] = timezone;
	wheather_data[city]['cname'] = cname || "";
    send(wheather_data, city, lat, lon, view);
    update();
}

function city_rotate(lon, lat, dn, dt) {
    var rotate = projection.rotate();
    var n = rotate[0];
    var t = rotate[1];
    if (!dn || !dt) {
        dn = (lon - n) / ROTATE_STEPS;
        dt = (lat - t) / ROTATE_STEPS;
    }
    n += dn;
    t += dt;
    projection.rotate([n, t, rotate[2]]);
    //projection.rotate([-lon, -lat, rotate[2]]); // сразу
    update();
    if (Math.abs(n - lon) > ROTATE_EPSILON)
        rotate_timer = setTimeout(city_rotate, ROTATE_TIME, lon, lat, dn, dt);
}

function make_feature(name, lon ,lat) {
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

function add_selected_city(city, lat, lon) {
    let city_feature = make_feature(city, lon, lat);
    cities = cities.concat([city_feature]);
    return city_feature;
}

function scale_projection(value) {
    let scale = projection.scale();
    //projection.scale(scale + Math.sign(value)*Math.abs(scale)**0.7);
    projection.scale(scale**(1 + value/700));
    if (projection.scale() < MIN_ZOOM) projection.scale(MIN_ZOOM);
    //console.log(projection.scale());
    update();

    geoGenerator.pointRadius(point_radius(scale));

    if (scale < 500) {
        sens = 0.25;
		city_min_dist = 0.04;
    } else {
        sens = 0.25 - scale/8000;
		//city_min_dist = 0.04 - scale/500000;
		//console.log(city_min_dist, scale/500000)
    }
    if (sens < 0.05) sens = 0.05;
}

function point_radius(s) {
    if (s > 1500) return 3;
    if (s < 1000) return 2;
    return s/500
}

function init() {
        if (!Array.concat) { Array.concat = Array.prototype.concat; }
        setMap();
        $("#scaleup").on("click", function() { scale_projection(SCALE_VAL) });
        $("#scaledown").on("click", function() { scale_projection(-SCALE_VAL) });
        $("#map").bind('mousewheel DOMMouseScroll', function(event){
            if (event.originalEvent.wheelDelta > 0 || event.originalEvent.detail < 0) {
                scale_projection(SCALE_VAL/2);
            }
            else {
                scale_projection(-SCALE_VAL/2);
            }
        });
}

// Подпрограмма настройки карты
function setMap() {
    // Высота и ширина карты
    width = WIDTH, height = WIDTH;
     
    // Создание объекта отрогональной проекции
    projection = d3.geo.orthographic()
        .scale(380)
        .rotate([0, 0])
        .translate([width / 2, height / 2])
        .clipAngle(90);

    context = d3.select('#map canvas')
      .node()
      .getContext('2d', { alpha: false });

    d3.select('#map canvas')
        .attr('width', width)
        .attr('height', height);

    geoGenerator = d3.geoPath()
      .projection(projection)
      .context(context);

    // Настойка размера точек
    geoGenerator.pointRadius(1.5);

    // Загрузка данных
    loadData();
}

function set_font_size(s) {
    let scale = projection.scale();
    let x = s + (scale / 400)**1.07;
	if (scale > 3000) {
		x = s + (scale / 400)**0.65;
	}
	//console.log(scale, x);
    context.font = x + "px Arial,Helvetica,sans-serif";
}

// Подпрограмма отрисовки глобуса со всем содержимым
function update() {
    set_font_size(12);
    context.fillStyle = SPACE_COLOR;
    context.fillRect(0, 0, width, height);
    context.lineWidth = 2.0;
    context.strokeStyle = EDGE_COLOR;

    // Сфера воды
    context.fillStyle = WATER_COLOR;
    context.beginPath();
    geoGenerator({type: 'Sphere'});
    context.fill();

    // Отображение границ стран
    for (let c = 0; c < Object.keys(country_by_color).length; c++) {
        let countries = country_by_color[c];
            context.fillStyle = colors[c];
            context.beginPath();
        for (let i = 0; i < countries.length; i++) {
            let country = countries[i];
            geoGenerator({type: 'FeatureCollection', features: [country]})
        }
            context.stroke();
            context.fill();
    }

    // Отображение линий рек
    var geojson = rivers;
    context.strokeStyle = RIVER_COLOR;
    context.lineWidth = 0.5;
    context.beginPath();
    for (var i = 0; i < geojson.length; i++) {
        var river = geojson[i];
        geoGenerator({type: 'FeatureCollection', features: [river]})
    }
    context.stroke();

    // Отображение озёр
    var geojson = lakes;
    context.strokeStyle = RIVER_COLOR;
    context.lineWidth = 0.5;
    context.fillStyle = WATER_COLOR;
    context.beginPath();
    for (var i = 0; i < geojson.length; i++) {
        var lake = geojson[i];
        geoGenerator({type: 'FeatureCollection', features: [lake]})
    }
    context.fill();
	context.stroke();
    
    // coastlines TODO WIP
    /*
    var geojson = coast;
    context.strokeStyle = RIVER_COLOR;
    context.lineWidth = 1.5;
    context.beginPath();
    for (var i = 0; i < geojson.length; i++) {
        var lake = geojson[i];
        geoGenerator({type: 'FeatureCollection', features: [lake]})
    }
	context.stroke();
    */
	
	draw_country_names();
    draw_cities_by_rank();

    // Отображение выбранного и ближайшего города
    if (near_city) {
        context.strokeStyle = NEAR_CITY_COLOR;
        context.lineWidth = 5;
        context.beginPath();
        geoGenerator({type: 'FeatureCollection', features: [near_city]})
        context.stroke();
        // Вывод названия у города
        show_town_text(near_city);
    }
    if (selected_city) {
        context.strokeStyle = SELECTED_CITY_COLOR;
        context.lineWidth = 5;
        context.beginPath();
        geoGenerator({type: 'FeatureCollection', features: [selected_city]})
        context.stroke();
        // Вывод названия у города
        show_town_text(selected_city);
    }
}

// Отображение названий стран
function draw_country_names() {
    var geojson = world.features;
    context.textAlign = 'center';
    context.fillStyle = COUNTRY_TEXT_COLOR;
    context.beginPath();
    for (let c = 0; c < Object.keys(country_by_color).length; c++) {
        let countries = country_by_color[c];
    for (let i = 0; i < countries.length; i++) {
        let country = countries[i];
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
            obj.geometry.coordinates = [country.geometry.coordinates[1]];
            obj.properties = country.properties;
            geo_center = geoGenerator.centroid(obj);
            //console.log(obj, geo_center, country);
            //continue;
        }
        let max_zoom = Math.floor(projection.scale() / 120);
        if (is_visible_dotp(projection.invert(geo_center))) {
            if (country.properties.LABELRANK < max_zoom) {
                context.fillText(get_country_name(country), geo_center[0], geo_center[1]); 
            }
        }
    }
	}
    context.stroke();
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

// Подпрограмма загрузки геоданных
function loadData() {
    // Запрос геоданных границ в topoJSON-формате и точек городов
    queue()
      .defer(d3.json, "static/geo/topoworld.json")  
      .defer(d3.json, "static/maptowns.json")  
      .defer(d3.json, "static/geo/topolakes.json")  
      .defer(d3.json, "static/geo/toporivers.json")  
      .defer(d3.json, "static/towns.json")  
      .defer(d3.json, "static/geo/topocitybig.json")  
      .defer(d3.json, "static/geo/topocoastlines.json")  
      .await(processData);  // обработка загруженных данных
}
   
// Подпрограмма обработки загруженных геоданных
function processData(error, worldMap, cityMap, lakesMap, riversMap, towns, t, coast) {
    if (error) return console.error(error);
    // Извлечение TopoJson данных и сохранение границ стран
    world = topojson.feature(worldMap, worldMap.objects.world);
    countries = world.features;
    // Извлечение TopoJson данных и сохранение береговых линий
    window.coast = topojson.feature(coast, coast.objects.coastlines).features;
    // Извлечение TopoJson данных и сохранение озёр
    lakes = topojson.feature(lakesMap, lakesMap.objects.lakes).features;
    // Извлечение TopoJson данных и сохранение рек
    rivers = topojson.feature(riversMap, riversMap.objects.rivers).features;

    // Извлечение TopoJson данных и сохранение городов
    tw = topojson.feature(t, t.objects.citybig).features;
    cities = tw; 

    // Распределение городов по уровням детализации
    for (let i = 0; i < tw.length; i++) {
        // Извлечение имени города
        let name = tw[i].properties.name_ru;
        if (name) {
            // Вычисление уровня детализации
            let lvl = Math.floor(tw[i].properties.min_zoom*10);
            // Сохранение в массиве городов с таким же уровнем
            if (!city_level[lvl]) city_level[lvl] = [];
            city_level[lvl].push(tw[i]);
            // Заполнение списка имён городов (для поиска)
            cities_names.push(name);
            // Заполнение списка городов и их координат
            cities_coords[name] = [tw[i].geometry.coordinates[1], tw[i].geometry.coordinates[0]];
        }
    }
    cities_coords = Object.assign({}, cities_coords, cityMap);

    // Список дополнительных городов
    //cities_names_add = Object.keys(towns);
    //cities_names = Array.concat(cities_names, cities_names_add);
    // Совмещение с городами карты
    // Координаты дополнительных городов
    // DEL cityMap, towns

    // Настройка автодополнения имён городов
    autocomplete_init();

    // Распределение стран в по цвету. В словарь Цвет->список стран. (Для оптимизации отрисовки)
    for (let i = 0; i < countries.length; i++) {
        let country = countries[i];
        // Вычисление индекса цвета
        let color_index = get_color_index(country);
        // Сохранение в массиве стран с таким же цветом
        if (!country_by_color[color_index]) country_by_color[color_index] = [];
        country_by_color[color_index].push(country);
    }

    // Отрисовать глобус
    update();

    // Обработчик поворода шара
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
                  show_wheather_data(human_coord(mouse_point), mouse_point[0], mouse_point[1]);
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
      })

    // Привязка обработчика клика на каждый из дней краткой сводки погоды
    for (let i = 0; i <= 10; i++)
        $("#day_" + i).parent()
            .on("click", function () {
                // Отобразить подробные данные по частям дня
                show_part_wheather(i);
				// Установка стиля выбранного дня
				for (let k = 0; k <= 10; k++) {
					$("#day_" + k).parent().removeClass("forecast_focused");
				}
				$("#day_" + i).parent().addClass("forecast_focused");
            });

    render_city(city_by_name("Рыбинск"), false);
    //console.log("Мир", world);
    //console.log("Города", cities);
    //console.log("Озёра", lakes);
    //console.log("Реки", rivers);
    //console.log("By rank", city_level);
    //console.log("All ", tw);
    //console.log("By color ", country_by_color);
    //console.log(worldMap);
    //console.log(cityMap);

    // Привязка обработчиков клика на кнопки переключения подробного прогноза на 5/10 дней
	$("#ten_toggle").on("click", function () {
		$("#ten").css("display", "table-row");
	});
	$("#five_toggle").on("click", function () {
		$("#ten").css("display", "none");
	});
}

// Подпрограмма форматирования координат
function human_coord(p) {
    // Широта latitude сев/юж
    // Долгода longitude вост/зап
    // 55°45′21″ с. ш. 37°37′04″ в. д.
    var lon = p[0];
    var lat = p[1];
	if (!lon || !lat) return null;
    var coord_text = "";

    coord_text += Math.abs(Math.floor(lat));
    if (lat > 0) {
        coord_text += "° c.ш. ";
    } else {
        coord_text += "° ю.ш. ";
    }

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
    //console.log(min_distance, nearest);
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
        update();
        // Отобразить погодные данные по ближайшему городу в подсказке
        make_wheather_text(nearest);
    }
}

// Подпрограмма отображения погоды города
function make_wheather_text(city) {
    // Извлечение координат и имени города
    var lon = city.geometry.coordinates[0]; 
    var lat = city.geometry.coordinates[1];
    var city_name = city.properties.name_ru;
    // Подставить имя города в поле ввода
    //$("#cities").val(city_name);
    // Вызов подпрограммы отображения погдных данных
    show_wheather_data(city_name, lon, lat);
}

// Подпрограмма формирования всплывающей подсказки
function show_wheather_data(city_name, lon, lat) {
	if (!city_name) return;
    // Формирование текста с данными
    //var text = "";
    //text += city_name;
    //text += "<br/>";
    var wheather_data = {};
    // Получение погодных данных в выбранной точке
    send(wheather_data, city_name, lat, lon, function (wheather_data) {
          // Обработка погодных данных и формирование текста для сводки
          wheather_data["city"] = city_name;
          // Формирование текста с погодной сводкой
        
          $("#tooltip_cityname").text(city_name);
          $("#tooltip_icon img").attr("src", make_icon(wheather_data[city_name]["icon"]));
          $("#tooltip_condition").text(human_condition(wheather_data[city_name]["condition"]));
          $("#tooltip_temp").text("Температура: " + human_temp_grad(wheather_data[city_name]["temp"]));
          $("#tooltip_hum").text("Влажность: " + wheather_data[city_name]["humidity"] + "%");
          $("#tooltip_wind").text("Ветер: " + human_wind(wheather_data[city_name]["wind_dir"], wheather_data[city_name]["wind_speed"]));

          $("#tooltip")
              .css("left", (mouse_xy[0] + 33) + "px")
              .css("top", (mouse_xy[1] + 47) + "px")
              .css("display", "block");

          //text += "<img class='tooltip_img' src='" + "https://yastatic.net/weather/i/icons/blueye/color/svg/" + wheather_data[city_name]["icon"] + ".svg" + "'/>";
          //text += human_condition(wheather_data[city_name]["condition"]);
          //text += "<br/>";
          //text += "Температура: ";
          ////text += human_temp(wheather_data[city_name]["temp"]) + "°";
          //text += "<br/>";
          //text += "Влажность: ";
          //text += wheather_data[city_name]["humidity"] + "%";
          ////text += "<br/>";
          //text += "Ветер: ";
          //text += human_wind(wheather_data[city_name]["wind_dir"], wheather_data[city_name]["wind_speed"]);
          //text += "<br/>";
          // Настройка всплывающей подсказки
          //tooltip.html(text)
              //.style("left", (mouse_xy[0] + 33) + "px")
              //.style("top", (mouse_xy[1] + 47) + "px")
              //.style("display", "block")
              //.style("opacity", 1);
          tooltip_timer = setTimeout(tooltip_hide, 5000);
    });
}

// Обработчик скрытия подсказки
function tooltip_hide(){
    //tooltip.style("opacity", 0)
        //.style("display", "none");
    $("#tooltip")
        .css("display", "none");
}

// конфигурации поля ввода городов с автодополнением
function autocomplete_init() {
    // При выборе города из подсказки
    $("#cities").autocomplete({
          source: cities_names,
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
}


// Вызов главной функции
init();

};

