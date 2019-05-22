var aitoff = d3.geoAitoff(); // DEL?
window.onload = function () {

var width, height, svg, path, projection;
var sens = 0.25;
var colors = ["#883", "#833", "#883", "#383", "#338", "#830", "#380"];
// Элемент всплывающей подсказки
var tooltip = d3.select("body").append("div").attr("class", "tooltip");
var tempById = {}; // DEL?

    function refresh_projection() {
            svg.selectAll("path.points").attr("d", path);
            svg.selectAll("path.land").attr("d", path);
            svg.selectAll("path.temp").attr("d", path);
            svg.selectAll("path.water").attr("d", path);
    }

    function scale_projection(value) {
        projection.scale(projection.scale() + value);
        refresh_projection();
    }

    function init() {
        setMap();
        $("#scaleup").on("click", function() { scale_projection(10) });
        $("#scaledown").on("click", function() { scale_projection(-10) });
        $("#map").bind('mousewheel DOMMouseScroll', function(event){
            if (event.originalEvent.wheelDelta > 0 || event.originalEvent.detail < 0) {
            console.log('scrolling');
                scale_projection(5);
            }
            else {
            console.log('scrolling');
                scale_projection(-5);
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
    // Настойка размера точек
    path.pointRadius(1.8);

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
      .await(processData);  // обработка загруженных данных
  }
   
  // Подпрограмма обработки загруженных геоданных
  function processData(error, worldMap, cityMap) {
    if (error) return console.error(error);
    console.log(worldMap);
    console.log(cityMap);
    var world = topojson.feature(worldMap, worldMap.objects.world);
    var cities = topojson.feature(cityMap, cityMap.objects.citymini).features;
    countries = world.features;
    console.log(world);
    console.log(cities);

    var world2 = svg.selectAll("path.land")
        .data(countries)
        .enter().append("path")
        .attr("class", "land")
        .attr("stroke-width", 2)
        .attr("stroke", "black")
        .attr("fill", function (d) { 
            var c = d.properties.MAPCOLOR7 || 0;
            var n = Math.abs(c % colors.length);
            return colors[n]; })
        .attr("d", path);

    svg.selectAll("path")
        .call(d3.behavior.drag()
        .origin(function() { var r = projection.rotate(); return {x: r[0] / sens, y: -r[1] / sens}; })
        .on("drag", function() {
            var rotate = projection.rotate();
            projection.rotate([d3.event.x * sens, -d3.event.y * sens, rotate[2]]);
            svg.selectAll("path.points").attr("d", path);
            svg.selectAll("path.land").attr("d", path);
            svg.selectAll("path.temp").attr("d", path);
            //console.log(path.centroid());
            //svg.selectAll("text.temp").attr("x", );
      }));

    cities.forEach(function(d) {
      //tempById[d.id] = d.name;
    });

    var citysvg = svg.selectAll("path.points")
        .data(cities)
        .enter().append("path")
        .attr("class", "points")
        .attr("d", path);

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
              view(wheather_data);
              $("#cities").val(city);
              //renderCities(city);
              // Формирование текста с погодной сводкой
              text += "Температура: ";
              text += wheather_data[d.properties.name_ru]["temp"] + "°";
              text += "<br/>";
              text += "Влажность: ";
              text += wheather_data[d.properties.name_ru]["humidity"] + "%";
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
};



