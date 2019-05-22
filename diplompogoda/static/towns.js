var xhr = new XMLHttpRequest();
xhr.open('GET', "static/towns.json", false);

xhr.onload = function() {
    window.cities = JSON.parse(this.responseText);
    };
xhr.send(); 
