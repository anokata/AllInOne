window.onload = function () {

var width, height, svg, path, projection;
var sens = 0.25;
var colors = ["#883", "#833", "#883", "#383", "#338", "#830", "#380"];
// Элемент всплывающей подсказки
var tooltip = d3.select("body").append("div").attr("class", "tooltip");
var tempById = {}; // DEL?
var addition_towns = [];


// Подпрограмма показывающая данные для выбранного города
function renderCities(city) {
    wheather_data = {};
    city_data = cities[city];
    console.log(city_data);
    lat = city_data[0];
    lon = city_data[1];
    add_selected_city(city, lat, lon);
    send(wheather_data, city, lat, lon, view);
    refresh_projection();
}

function add_selected_city(city, lat, lon) {
    var town = {
        "type":"Feature",
        "properties":{
            "name_ru": city
        },
        "geometry":{
            "type": "Point",
            "coordinates": [lon, lat]
        }
    }
    addition_towns.push(town);
    console.log(addition_towns);
    add_cities(addition_towns);
}


    function refresh_projection() {
            svg.selectAll("path.points").attr("d", path2);
            svg.selectAll("path.points_dot").attr("d", path);
            svg.selectAll("path.land").attr("d", path);
            svg.selectAll("path.temp").attr("d", path);
            svg.selectAll("path.water").attr("d", path);
            svg.selectAll("path.lakes").attr("d", path);
            svg.selectAll("path.rivers").attr("d", path);
    }

    function scale_projection(value) {
        projection.scale(projection.scale() + value);
        refresh_projection();
    }

    function init() {
        setMap();
        $("#scaleup").on("click", function() { scale_projection(30) });
        $("#scaledown").on("click", function() { scale_projection(-30) });
        $("#map").bind('mousewheel DOMMouseScroll', function(event){
            if (event.originalEvent.wheelDelta > 0 || event.originalEvent.detail < 0) {
            console.log('scrolling');
                scale_projection(15);
            }
            else {
            console.log('scrolling');
                scale_projection(-15);
            }
        });
    }

  // Подпрограмма настройки карты
  function setMap() {
    // Высота и ширина карты
    width = 1000, height = 800;
     
    // Создание и настройка SVG контейнера карты
    svg = d3.select('#map').append('svg')
        .attr('width', width)
        .attr('height', height);

    // Создание объекта отрогональной проекции
    projection = d3.geo.orthographic()
        .scale(380)
        .rotate([0, 0])
        .translate([width / 2, height / 2])
        .clipAngle(90);

    path = d3.geo.path().projection(projection);
    path2  = d3.geo.path().projection(projection);
    // Настойка размера точек
    path.pointRadius(1.5);
    path2.pointRadius(6.0);

    // Добавление круга океанов
    svg.append("path")
        .datum({type: "Sphere"})
        .attr("class", "water")
        .attr("d", path);


    // Загрузка данных
    loadData();
  }
   
  // Подпрограмма загрузки геоданных
  function loadData() {
    // Запрос геоданных границ в topoJSON-формате и точек городов
    queue()
      .defer(d3.json, "static/geo/topoworld.json")  
      .defer(d3.json, "static/geo/topocitymini.json")  
      .defer(d3.json, "static/geo/topolakes.json")  
      .defer(d3.json, "static/geo/toporivers.json")  
      .await(processData);  // обработка загруженных данных
  }
   
  // Подпрограмма обработки загруженных геоданных
  function processData(error, worldMap, cityMap, lakesMap, riversMap) {
    if (error) return console.error(error);
    console.log(worldMap);
    console.log(cityMap);
    var world = topojson.feature(worldMap, worldMap.objects.world);
    var cities = topojson.feature(cityMap, cityMap.objects.citymini).features;
    var lakes = topojson.feature(lakesMap, lakesMap.objects.lakes).features;
    var rivers = topojson.feature(riversMap, riversMap.objects.rivers).features;
    countries = world.features;
    console.log("Мир", world);
    console.log("Города", cities);
    console.log("Озёра", lakes);
    console.log("Реки", rivers);

      // Добавление границ стран
    var world2 = svg.selectAll("path.land")
        .data(countries)
        .enter().append("path")
        .attr("class", "land")
        .attr("stroke-width", 1.5)
        .attr("stroke", "black")
        .attr("fill", function (d) { 
            var c = d.properties.MAPCOLOR7 || 0;
            var n = Math.abs(c % colors.length);
            return colors[n]; })
        .attr("d", path);

      // Обработчик поворода шара
    svg.selectAll("path")
        .call(d3.behavior.drag()
        .origin(function() { var r = projection.rotate(); return {x: r[0] / sens, y: -r[1] / sens}; })
        .on("drag", function() {
            var rotate = projection.rotate();
            projection.rotate([d3.event.x * sens, -d3.event.y * sens, rotate[2]]);
            refresh_projection();
            //console.log(path.centroid());
            //svg.selectAll("text.temp").attr("x", );
      }));

    add_cities(cities);

    // Добавление озёр
    var lakes_svg = svg.selectAll("path.lakes")
        .data(lakes)
        .enter().append("path")
        .attr("class", "lakes")
        .attr("stroke-width", 0)
        .attr("fill", "#234c75")
        .attr("d", path);

    // Добавление рек
    var rivers_svg = svg.selectAll("path.rivers")
        .data(rivers)
        .enter().append("path")
        .attr("class", "rivers")
        .attr("stroke-width", 1)
        .attr("stroke", "#234c75")
        .attr("fill", "none")
        .attr("d", path);


      /*
    svg.selectAll(".temp")
        .data(cities)
        .enter().append("text")
        .attr("d", path)
        .attr("class", "temp")
        .attr("transform", function(d) { return "translate(" + projection(d.geometry.coordinates) + ")"; })
        .attr("dy", ".35em")
        .text(function(d) { return d.properties.name; });
        */

      /*
    var pointsd = 
[
  {
    "type": "Feature",
    "geometry": {
      "type": "Point",
      "coordinates": [
        38.5,
        58.5
      ]
    }
  }
];
    svg.selectAll("path.temp")
        .data(pointsd)
        .enter().append("path")
        .attr("class", "temp")
        .attr("stroke-width", 5)
        .attr("stroke", "white")
        .attr("fill", "white")
        .attr("d", path);

    svg.selectAll("text")
        .data(pointsd)
        .enter()
        .append("text")
        .attr("transform", function(d) { return "translate(" + 
                projection([d.geometry.coordinates[0], d.geometry.coordinates[1]]) + ")" })
        .attr("class", "temp")
        .text("+88")
        .attr("x", function(d) { console.log(d); return d.geometry.coordinates[0]; })
        .attr("y", function(d) { return d.geometry.coordinates[1]; })
        .attr("font-family", "sans-serif")
        .attr("font-size", "20px")
        .attr("fill", "red")
      ;
  */
  }
   
  // Вызов главной функции
  init();

function add_cities(cities) {
    // Добавление точек городов
    var citysvg = svg.selectAll("path.points_dot")
        .data(cities)
        .enter().append("path")
        .attr("class", "points_dot")
        .attr("d", path);

    var citysvg = svg.selectAll("path.points")
        .data(cities)
        .enter().append("path")
        .attr("class", "points")
        .attr("d", path2);

    // Установка обработчика при наведении мыши показывающего подсказку с данными
    citysvg.on("mouseover", function(d) {
        // Получение координат выбранной точки
        lat = d.geometry.coordinates[1];
        lon = d.geometry.coordinates[0];
        // Формирование текста с данными
        var text = "";
        text += d.properties.name_ru || "";
        text += "<br/>";
        var wheather_data = {};
        var city = d.properties.name_ru;
        // Получение погодных данных в выбранной точке
        send(wheather_data, d.properties.name_ru, lat, lon, function (wheather_data) {
              // Обработка погодных данных и формирование текста для сводки
              wheather_data["city"] = d.properties.name_ru;
              // Вывод текста с данными на веб-странице
              //view(wheather_data);
              $("#cities").val(city);
              //renderCities(city);
              // Формирование текста с погодной сводкой
			  text += "<img class='tooltip_img' src='" + "https://yastatic.net/weather/i/icons/blueye/color/svg/" + wheather_data[city]["icon"] + ".svg" + "'/>";
			  text += human_condition(wheather_data[city]["condition"]);
			  text += "<br/>";
              text += "Температура: ";
              text += human_temp(wheather_data[d.properties.name_ru]["temp"]) + "°";
              text += "<br/>";
              text += "Влажность: ";
              text += wheather_data[d.properties.name_ru]["humidity"] + "%";
              text += "<br/>";
              text += "Ветер: ";
              text += human_wind(wheather_data[city]["wind_dir"], wheather_data[city]["wind_speed"]);
              text += "<br/>";
              // Настройка всплывающей подсказки
              tooltip.html(text)
                  .style("left", (d3.event.pageX + 7) + "px")
                  .style("top", (d3.event.pageY - 15) + "px")
                  .style("display", "block")
                  .style("opacity", 1)
                .on("mousemove", function(d) {
                      tooltip.style("left", (d3.event.pageX + 7) + "px")
                      .style("top", (d3.event.pageY - 15) + "px");
                });
        });
    });
    // Обработчик скрытия подсказки
    citysvg.on("mouseout", function(d) {
              tooltip.style("opacity", 0)
              .style("display", "none");
            })
}

// конфигурации поля ввода городов с автодополнением
$("#cities").autocomplete({
      source: cities_names,
      select: function(event, ui) {
          console.log(ui.item.value);
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

};



