
cities = {
"Абаза": ["52.651657",	"90.088572"],
"Абакан": ["53.721152",	"91.442387"],
"Абдулино": ["53.677839",	"53.647263"]
}
default_city = "x";

document.addEventListener("DOMContentLoaded", ready);

function renderCities() {
    wheather_data = {};
    // for (var c in cities) {
    //     send(wheather_data, c, cities[c][0], cities[c][1]);
    // }
    lat = document.getElementById("lat");
    lon = document.getElementById("lon");
    send(wheather_data, default_city, lat, lon, view);
}

function view(wheather_data) {
    console.log(wheather_data);
    var info = "";
    //info += wheather_data[default_city]["info"];
    //info += "<br/>";
    info += "Температура: ";
    info += wheather_data[default_city]["temp"] + "°";
    info += "<br/>";
    info += "Влажность: ";
    info += wheather_data[default_city]["humidity"] + "%";
    info += "<br/>";
    var info_div = document.getElementById("wheather");
    info_div.innerHTML = info;
}

function send(wheather_data, city, lat, lon, f) {
    var query = 'http://127.0.0.1:5000/pogoda/'
    //var query = 'http://ksilenomen.pythonanywhere.com/pogoda/'
    query += lat;
    query += "/" + lon;
    var xhr = new XMLHttpRequest();
    xhr.open('GET', query, false);
    
    xhr.onload = function() {
        data = JSON.parse(this.responseText);
        wheather_data[city] = {
            "temp": data['fact']['temp'],
            "condition": data['fact']['condition'],
            "humidity": data['fact']['humidity'],
            "info": data['info']['url'],
        };
        if (f) f(wheather_data);
        //console.log(wheather_data);
        return data;
    }
  
    xhr.send(); 
}

function ready() {
}
   

