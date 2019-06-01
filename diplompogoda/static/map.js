window.onload = function () {

const WIDTH = 800;
const CITY_MIN_DIST = 0.04;
const MOUSE_PAUSE = 200;
const SCALE_VAL = 50;
const ROTATE_EPSILON = 5;
const ROTATE_STEPS = 12;
const NEAR_CITY_COLOR = '#d33';
const SELECTED_CITY_COLOR = '#3d3';
const WATER_COLOR = "#b1d5e5";
const SPACE_COLOR = "#7397a4";
const CITY_COLOR = "#333";
const COUNTRY_TEXT_COLOR = "#333";
const RIVER_COLOR = '#0e67a4';
const MAX_DISTANCE = 1;
const MIN_ZOOM = 300;
const EDGE_COLOR = '#111';
const ROTATE_TIME = 10;
var width, height, projection;
var sens = 0.25;
var colors = ["#dda6ce", "#aebce1", "#fbbb74", "#b9d888", "#fffac2", "#b4cbb7", "#e4c9ae", "#f7a98e", "#ffe17e"];
// Элемент всплывающей подсказки
var tooltip = d3.select("body").append("div").attr("class", "tooltip");
var context, geoGenerator;
var world, cities, lakes, rivers;
var mouse_timer, mouse_point, mouse_xy;
var tooltip_timer, rotate_timer;
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
    console.log("T1", city, timezone);
    // TODO если null то искать ближайшую
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
    } else {
        sens = 0.25 - scale/8000;
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
    context.font = x + "px Arial,Helvetica,sans-serif";
}

// Подпрограмма отрисовки глобуса со всем содержимым
function update() {
    set_font_size(12);
    context.fillStyle = SPACE_COLOR;
    //context.clearRect(0, 0, width, height);
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

    var geojson = rivers;
    context.strokeStyle = RIVER_COLOR;
    context.lineWidth = 0.5;
    context.beginPath();
    for (var i = 0; i < geojson.length; i++) {
        var river = geojson[i];
        geoGenerator({type: 'FeatureCollection', features: [river]})
    }
    context.stroke();

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
	
	draw_country_names();
	
	set_font_size(10);
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
        if (country.properties.NAME_RU == "Франция") continue;
        let geo_center = geoGenerator.centroid(country);
        let max_zoom = Math.floor(projection.scale() / 120);
        if (is_visible_dotp(projection.invert(geo_center))) {
            if (country.properties.LABELRANK < max_zoom) {
                context.fillText(country.properties.NAME_RU, geo_center[0], geo_center[1]); 
            }
        }
    }
	}
    context.stroke();
}

// Вывод названия у города
function show_town_text(town) {
    if (is_visible_dotp(town.geometry.coordinates)) {
        var xy = projection(town.geometry.coordinates);
        context.fillText(town.properties.name_ru || "", xy[0], xy[1] - 5); 
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
function draw_cities_by_rank() {
    context.strokeStyle = CITY_COLOR;
    context.lineWidth = 0.5;
    context.fillStyle = CITY_COLOR;
    context.beginPath();
    var max_rank = Math.floor(Math.sqrt(projection.scale()*1.5));
    //console.log(projection.scale(), max_rank);
    for (var l = 0; l < max_rank; l++) {
        var geojson = city_level[l];
        if (geojson)
            for (var i = 0; i < geojson.length; i++) {
                var city = geojson[i];
                geoGenerator({type: 'FeatureCollection', features: [city]})

                // Вывод названия у города
                show_town_text(city);
            }
    }
    context.fill();
}

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
      .defer(d3.json, "static/geo/topocitymid.json")  
      .await(processData);  // обработка загруженных данных
}
   
// Подпрограмма обработки загруженных геоданных
function processData(error, worldMap, cityMap, lakesMap, riversMap, towns, t) {
    if (error) return console.error(error);
    world = topojson.feature(worldMap, worldMap.objects.world);

    tw = topojson.feature(t, t.objects.citymid).features;
    for (let i = 0; i < tw.length; i++) {
        let name = tw[i].properties.name_ru;
        if (name) {
            let lvl = Math.floor(tw[i].properties.min_zoom*10);
            if (!city_level[lvl]) city_level[lvl] = [];
            city_level[lvl].push(tw[i]);
            cities_names.push(name);
            cities_coords[name] = [tw[i].geometry.coordinates[1], tw[i].geometry.coordinates[0]];
        }
    }

    cities = tw; 
    // Список дополнительных городов
    cities_names_add = Object.keys(towns);
    cities_names = Array.concat(cities_names, cities_names_add);
    // TODO Удалить дубликаты function additional_city()
    // Совмещение с городами карты
    // Координаты дополнительных городов
    cities_coords = Object.assign({}, cities_coords, cityMap);
    autocomplete_init();
    lakes = topojson.feature(lakesMap, lakesMap.objects.lakes).features;
    rivers = topojson.feature(riversMap, riversMap.objects.rivers).features;
    countries = world.features;
    for (let i = 0; i < countries.length; i++) {
        let country = countries[i];
        let color_index = get_color_index(country);
        if (!country_by_color[color_index]) country_by_color[color_index] = [];
        country_by_color[color_index].push(country);
    }

    update();
      // Обработчик поворода шара
    d3.selectAll("canvas")
        .call(d3.behavior.drag()
        .origin(function() { var r = projection.rotate(); return {x: r[0] / sens, y: -r[1] / sens}; })
        .on("drag", function() {
            var rotate = projection.rotate();
            projection.rotate([d3.event.x * sens, -d3.event.y * sens, rotate[2]]);
            update();
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
          //? Если совпадёт с городом
          clearTimeout(mouse_timer);
          // Запуск таймера остановки мыши для вывода краткой сводки погоды в ближайшем городе
          mouse_timer = setTimeout(mouse_stopped, MOUSE_PAUSE); //TODO
          mouse_point = get_mouse_geopoint(this);
          mouse_xy = d3.mouse(this);
          tooltip_hide();
          clearTimeout(tooltip_timer);
      })
    d3.selectAll("canvas")
      .on("mouseup", function () {
          if (!isDragging) {
              var mouse_point = get_mouse_geopoint(this);
              // Если совпадёт с городом c определённой точностью
              var nearest = nearest_city(mouse_point);
              if (nearest) {
                  //selected_city = nearest;
                  render_city(nearest);
              } else {
                    show_wheather_data(human_coord(mouse_point), mouse_point[0], mouse_point[1]);
                  // TODO ближайший город - регион
                    render_town(human_coord(mouse_point), mouse_point[0], mouse_point[1], false);
              }
          }
          isDragging = false;
          startingPos = [];
      })

    for (let i = 0; i < 6; i++)
        $("#day_" + i).parent()
            .on("click", function () {
                show_part_wheather(i);
            });

    render_city(city_by_name("Рыбинск"), false);
    //var t1 = performance.now();
    //console.log("processData " + (t1 - t0) + " ms")
    //console.log("Мир", world);
    //console.log("Города", cities);
    //console.log("Озёра", lakes);
    //console.log("Реки", rivers);
    //console.log("By rank", city_level);
    //console.log("All ", tw);
    console.log("By color ", country_by_color);
    // console.log(worldMap);
    //console.log(cityMap);
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
	if (!city_name) return;
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
            render_city(city_by_name(ui.item.value));
          }
    });
    $("#cities").keypress(function(e){
        if(e.keyCode==13) {
            var city = upper_first($("#cities").val());
            $("#cities").val(city);
            render_city(city_by_name(city));
        }
    });
}


// Вызов главной функции
init();

};



