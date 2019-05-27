var xhr = new XMLHttpRequest();
xhr.open('GET', "static/towns.json", false);

xhr.onload = function() {
    window.cities_coords = JSON.parse(this.responseText);
    };
xhr.send(); 
