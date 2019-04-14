var aitoff = d3.geoAitoff();
window.onload = function () {

var width, height, svg, path, projection;
var sens = 0.25;

  function init() {
    setMap();
  }
   
  function setMap() {
    width = 818, height = 600;
     
    svg = d3.select('#map').append('svg')
        .attr('width', width)
        .attr('height', height);

    projection = d3.geo.orthographic()
        .scale(245)
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
    console.log(worldMap);
    var world = topojson.feature(worldMap, worldMap.objects.world);
    var cities = topojson.feature(cityMap, cityMap.objects.citybig).features;
    countries = world.features;
    //var map = svg.append("g");
    console.log(world);
    console.log(cityMap);
    console.log(cities);


    var world2 = svg.selectAll("path.land")
        .data(countries)
        .enter().append("path")
        .attr("class", "land")
        .attr("d", path)
        .call(d3.behavior.drag()
        .origin(function() { var r = projection.rotate(); return {x: r[0] / sens, y: -r[1] / sens}; })
        .on("drag", function() {
            var rotate = projection.rotate();
            projection.rotate([d3.event.x * sens, -d3.event.y * sens, rotate[2]]);
            svg.selectAll("path.points").attr("d", path);
            svg.selectAll("path.land").attr("d", path);
      }));

    var citysvg = svg.selectAll("path.points")
        .data(cities)
        .enter().append("path")
        .attr("class", "points")
        .attr("d", path);
  }
   
  init();
};
