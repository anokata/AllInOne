var aitoff = d3.geoAitoff();
window.onload = function () {

var width, height, svg, path, projection;
var sens = 0.25;
var colors = ["#883", "#833", "#883", "#383", "#338", "#830", "#380"];
//colors = ["#a6cee3", "#1f78b4", "#b2df8a", "#33a02c", "#fb9a99", "#e31a1c", "#fdbf6f"]

  function init() {
    setMap();
  }
   
  function setMap() {
    width = 1000, height = 800;
     
    svg = d3.select('#map').append('svg')
        .attr('width', width)
        .attr('height', height);

    projection = d3.geo.orthographic()
        .scale(380)
        .rotate([0, 0])
        .translate([width / 2, height / 2])
        .clipAngle(90);

    path = d3.geo.path().projection(projection);
    path.pointRadius(1.5);

    //Adding water 
    svg.append("path")
        .datum({type: "Sphere"})
        .attr("class", "water")
        .attr("d", path);


    loadData();
  }
   
  function loadData() {
    // карта в topoJSON-формате
    queue()
      .defer(d3.json, "static/geo/topoworld.json")  
      .defer(d3.json, "static/geo/topocitybig.json")  
      .await(processData);  // обработка загруженных данных
  }
   
  function processData(error, worldMap, cityMap) {
    if (error) return console.error(error);
    var world = topojson.feature(worldMap, worldMap.objects.world);
    var cities = topojson.feature(cityMap, cityMap.objects.citybig).features;
    countries = world.features;
    console.log(worldMap);
    console.log(cityMap);
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
            //console.log(d, c);
            //var n = Math.round(d.geometry.coordinates[0][0][0]) || 0;
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
      }));

    var citysvg = svg.selectAll("path.points")
        .data(cities)
        .enter().append("path")
        .attr("class", "points")
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
        .attr("d", path)
        .append("text")
        .attr("class", "temp")
        .text("+88")
        .attr("font-family", "sans-serif")
        .attr("font-size", "20px")
        .attr("fill", "red")
      ;
  }
   
  init();
};
