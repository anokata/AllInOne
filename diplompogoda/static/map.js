window.onload = function () {

const WIDTH = 800;
const CITY_MIN_DIST = 0.04;
const MOUSE_PAUSE = 200;
const SCALE_VAL = 50;
const ROTATE_EPSILON = 5;
const ROTATE_STEPS = 10;
const NEAR_CITY_COLOR = '#d33';
const SELECTED_CITY_COLOR = '#3d3';
const WATER_COLOR = "#234c75";
const SPACE_COLOR = "#82a2ad";
const MAX_DISTANCE = 1;
var width, height, projection;
var sens = 0.25;
var colors = ["#573", "#aa5", "#a55", "#5a5", "#27a", "#a50", "#6a2"];
// Элемент всплывающей подсказки
var tooltip = d3.select("body").append("div").attr("class", "tooltip");
var context, geoGenerator;
var world, cities, lakes, rivers;
var mouse_timer, mouse_point, mouse_xy;
var tooltip_timer, rotate_timer;
var isDragging = false;
var startingPos = [];
var near_city, selected_city;
var city_level = {0:[], 1:[], 2:[], 3:[], 4:[], 5:[], 6:[], 7:[], 8:[], 9:[], 10:[], 11:[]};


// Подпрограмма показывающая данные для выбранного города
function renderCities(city, lon, lat) {
    wheather_data = {};
    if (!lon || !lat) {
        city_data = cities_coords[city];
        lat = city_data[0];
        lon = city_data[1];
    }
    // Повернуть до этого города
    rotate_timer = setTimeout(city_rotate, 50, -lon, -lat);

    selected_city = make_feature(city, lon, lat);
    near_city = undefined;
            
    //console.log(city, lon, lat);
    add_selected_city(city, lat, lon);
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
        rotate_timer = setTimeout(city_rotate, 50, lon, lat, dn, dt);
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
    cities = cities.concat([make_feature(city, lon, lat)]);
}

function scale_projection(value) {
    projection.scale(projection.scale() + value);
    //console.log(projection.scale());
    update();
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

// Подпрограмма отрисовки глобуса со всем содержимым
function update() {
    context.fillStyle = SPACE_COLOR;
    //context.clearRect(0, 0, width, height);
    context.fillRect(0, 0, width, height);
    context.lineWidth = 2.0;
    context.strokeStyle = '#000';

    // Сфера воды
    context.fillStyle = WATER_COLOR;
    context.beginPath();
    geoGenerator({type: 'Sphere'});
    context.stroke();
    context.fill();

    // Отображение границ стран
    var geojson = world.features;
    for (var i = 0; i < geojson.length; i++) {
        var country = geojson[i];
        context.fillStyle = get_color(country);
        context.beginPath();
        geoGenerator({type: 'FeatureCollection', features: [country]})
        context.stroke();
        context.fill();
    }

    // TODO WIP
    context.textAlign = 'center';
    context.fillStyle = "#db8"
    context.beginPath();
    for (var i = 0; i < geojson.length; i++) {
        var country = geojson[i];
        var geo_center = geoGenerator.centroid(country);
        if (is_visible_dotp(projection.invert(geo_center))) {
            //console.log(country.properties.LABELRANK);
            var max_zoom = Math.floor(projection.scale() / 120);
            if (country.properties.LABELRANK < max_zoom) {
            //if (country.properties.LABELRANK < 3)
                context.fillText(country.properties.NAME_RU, geo_center[0], geo_center[1]); 
            }
        }
    }
    context.stroke();

    var geojson = rivers;
    context.strokeStyle = '#00f';
    context.lineWidth = 0.5;
    context.beginPath();
    for (var i = 0; i < geojson.length; i++) {
        var river = geojson[i];
        geoGenerator({type: 'FeatureCollection', features: [river]})
    }
    context.stroke();

    var geojson = lakes;
    context.strokeStyle = '#00f';
    context.lineWidth = 0.5;
    context.fillStyle = WATER_COLOR;
    context.beginPath();
    for (var i = 0; i < geojson.length; i++) {
        var lake = geojson[i];
        geoGenerator({type: 'FeatureCollection', features: [lake]})
    }
    context.fill();
    //draw_cities(cities);
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

// Вывод названия у города
function show_town_text(town) {
    if (is_visible_dotp(town.geometry.coordinates)) {
        var xy = projection(town.geometry.coordinates);
        context.fillText(town.properties.name_ru, xy[0], xy[1]); 
    }
}

function is_visible_dot(lat, lon) {
    var rlon = projection.rotate()[0];
    var rlat = projection.rotate()[1];
    return d3.geoDistance([lon, lat], [-rlon, -rlat]) < MAX_DISTANCE;
}
function is_visible_dotp(geopoint) {
    var rlon = projection.rotate()[0];
    var rlat = projection.rotate()[1];
    var lon = geopoint[0];
    var lat = geopoint[1];
    return d3.geoDistance([lon, lat], [-rlon, -rlat]) < MAX_DISTANCE;
}

// Подпрограмма отображения точек городов
function draw_cities(geojson) {
    context.strokeStyle = '#eee';
    context.lineWidth = 0.5;
    context.fillStyle = "#eee";
    context.beginPath();
    for (var i = 0; i < geojson.length; i++) {
        var city = geojson[i];
        geoGenerator({type: 'FeatureCollection', features: [city]})

        // Вывод названия у города
        // TODO WIP
        //show_town_text(city);
    }
    context.fill();
}

function draw_cities_by_rank() {
    context.strokeStyle = '#eee';
    context.lineWidth = 0.5;
    context.fillStyle = "#eee";
    context.beginPath();
    var max_rank = Math.floor(projection.scale() / 14);
    for (var l = 0; l < max_rank; l++) {
        var geojson = city_level[l];
    if (geojson)
    for (var i = 0; i < geojson.length; i++) {
        var city = geojson[i];
        geoGenerator({type: 'FeatureCollection', features: [city]})

        // Вывод названия у города
        // TODO WIP
        show_town_text(city);
    }
    }
    context.fill();
}

// Функция вычисления цвета страны
function get_color(d) { 
    var c = d.properties.MAPCOLOR7 || 0;
    var n = Math.abs(c % colors.length);
    return colors[n]; 
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
      .defer(d3.json, "static/geo/topocitymid.json")  
      .await(processData);  // обработка загруженных данных
}
   
// Подпрограмма обработки загруженных геоданных
function processData(error, worldMap, cityMap, lakesMap, riversMap, towns, t) {
    if (error) return console.error(error);
    // console.log(worldMap);
    console.log(cityMap);
    world = topojson.feature(worldMap, worldMap.objects.world);

    // TODO WIP
    tw = topojson.feature(t, t.objects.citymid).features;
    console.log("All ", tw);
    for (i = 0; i < tw.length; i++) {
        var lvl = Math.floor(tw[i].properties.min_zoom*10);
        if (!city_level[lvl]) city_level[lvl] = [];
        city_level[lvl].push(tw[i]);
    }
    console.log("By rank", city_level);

    cities = [];
    cities_names = Object.keys(cityMap);
    Object.keys(cityMap).map(
        function(key, index) { 
            cities.push(make_feature(key, cityMap[key][1], cityMap[key][0])); 
        });
    // Список дополнительных городов
    cities_names_add = Object.keys(towns);
    // Координаты дополнительных городов
    window.cities_coords = towns;
    // Совмещение с городами карты
    cities_coords = Object.assign({}, cities_coords, cityMap);
    // Слияние списков имён городов
    cities_names = Array.concat(cities_names, cities_names_add);
    autocomplete_init();
    lakes = topojson.feature(lakesMap, lakesMap.objects.lakes).features;
    rivers = topojson.feature(riversMap, riversMap.objects.rivers).features;
    countries = world.features;
    console.log("Мир", world);
    console.log("Города", cities);
    console.log("Озёра", lakes);
    console.log("Реки", rivers);

    update();
      // Обработчик поворода шара
    d3.selectAll("canvas")
        .call(d3.behavior.drag()
        .origin(function() { var r = projection.rotate(); return {x: r[0] / sens, y: -r[1] / sens}; })
        .on("drag", function() {
            var rotate = projection.rotate();
            projection.rotate([d3.event.x * sens, -d3.event.y * sens, rotate[2]]);
            update();
            //console.log("drag");
      }));


    $("canvas")
        .mousedown(function (evt) {
            isDragging = false;
            startingPos = [evt.pageX, evt.pageY];
        })
        .mousemove(function (evt) {
            if (!(evt.pageX === startingPos[0] && evt.pageY === startingPos[1])) {
                isDragging = true;
            }
        });

    d3.selectAll("canvas")
      .on("mousedown", function() {
          clearTimeout(tooltip_timer);
          clearTimeout(rotate_timer);
      })
      .on("mousemove", function() {
          // Если совпадёт с городом
          //console.log(projection.invert(d3.mouse(this)));
          clearTimeout(mouse_timer);
          mouse_timer = setTimeout(mouse_stopped, MOUSE_PAUSE);
          mouse_point = get_mouse_geopoint(this);
          mouse_xy = d3.mouse(this);
          tooltip_hide();
          clearTimeout(tooltip_timer);
      })
    d3.selectAll("canvas")
      .on("mouseup", function () {
          var mouse_point = get_mouse_geopoint(this);
          // Если совпадёт с городом c определённой точностью
          var nearest = nearest_city(mouse_point);
          if (nearest) {
              //selected_city = nearest;
              //console.log(nearest, nearest.properties.name_ru);
              renderCities(nearest.properties.name_ru, nearest.geometry.coordinates[0], nearest.geometry.coordinates[1]);
          } else {
            if (!isDragging) {
                show_wheather_data(human_coord(mouse_point), mouse_point[0], mouse_point[1]);
                // TODO Если есть населённый пунк рядом то подробно
            }
          }
          isDragging = false;
          startingPos = [];
      })
      // Добавление границ стран

    renderCities("Рыбинск");
}

// Подпрограмма форматирования координат
function human_coord(p) {
    // Широта latitude сев/юж
    // Долгода longitude вост/зап
    // 55°45′21″ с. ш. 37°37′04″ в. д.
    var lon = p[0];
    var lat = p[1];
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
   
// Подпрограмма извлечения координат указателся мыши
function get_mouse_geopoint(self) {
          var lon, lat;
          lon = projection.invert(d3.mouse(self))[0];
          lat = projection.invert(d3.mouse(self))[1];
          //console.log(lon, lat);
          return [lon, lat];
}

// Подпрограмма поиска ближайшего города
function nearest_city(p) {
    // Вычислим расстояние между точкой мыши и каждым городом
    var nearest;
    var min_distance = 10000000;

    // TODO WIP RANK
    var max_rank = Math.floor(projection.scale() / 14);
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
    if (min_distance < CITY_MIN_DIST) {
        return nearest;
    } else return false;
}

// Подпрограмма обработки остановки указателя
function mouse_stopped() {
    //console.log('stop', mouse_point);
    var nearest = nearest_city(mouse_point);
    if (nearest) {
        //console.log(nearest, nearest.properties.name_ru);
        near_city = nearest;
        update();
        make_wheather_text(nearest);
    }
}

// Подпрограмма отображения погоды города
function make_wheather_text(city) {
    var lon = city.geometry.coordinates[0]; 
    var lat = city.geometry.coordinates[1];
    var city_name = city.properties.name_ru;
    $("#cities").val(city_name);
    show_wheather_data(city_name, lon, lat);
}

// Подпрограмма формирования всплывающей подсказки
function show_wheather_data(city_name, lon, lat) {
    // Формирование текста с данными
    var text = "";
    text += city_name;
    text += "<br/>";
    var wheather_data = {};
    // Получение погодных данных в выбранной точке
    send(wheather_data, city_name, lat, lon, function (wheather_data) {
          // Обработка погодных данных и формирование текста для сводки
          wheather_data["city"] = city_name;
          // Формирование текста с погодной сводкой
          text += "<img class='tooltip_img' src='" + "https://yastatic.net/weather/i/icons/blueye/color/svg/" + wheather_data[city_name]["icon"] + ".svg" + "'/>";
          text += human_condition(wheather_data[city_name]["condition"]);
          text += "<br/>";
          text += "Температура: ";
          text += human_temp(wheather_data[city_name]["temp"]) + "°";
          text += "<br/>";
          text += "Влажность: ";
          text += wheather_data[city_name]["humidity"] + "%";
          text += "<br/>";
          text += "Ветер: ";
          text += human_wind(wheather_data[city_name]["wind_dir"], wheather_data[city_name]["wind_speed"]);
          text += "<br/>";
          // Настройка всплывающей подсказки
          tooltip.html(text)
              .style("left", (mouse_xy[0] + 33) + "px")
              .style("top", (mouse_xy[1] + 47) + "px")
              .style("display", "block")
              .style("opacity", 1);
          tooltip_timer = setTimeout(tooltip_hide, 5000);
    });
}

// Обработчик скрытия подсказки
function tooltip_hide(){
    tooltip.style("opacity", 0)
        .style("display", "none");
}

// конфигурации поля ввода городов с автодополнением
function autocomplete_init() {
    $("#cities").autocomplete({
          source: cities_names,
          select: function(event, ui) {
              //console.log(ui.item.value);
              renderCities(ui.item.value);
          }
    });
    $("#cities").keypress(function(e){
        if(e.keyCode==13) {
            var city = upper_first($("#cities").val());
            $("#cities").val(city);
            renderCities(city);
        }
    });
}


// Вызов главной функции
init();

};



