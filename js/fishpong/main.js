window.onload = main;

function main() {
    var field_container = document.querySelector("#field");
    var field = make_field(4, 6);
    draw_field(field, field_container);
}

function draw_field(field, container) {
    container.innerHTML = '';
    for (var x = 0; x < field.width; x++) {
        var row = document.createElement('tr');
        container.appendChild(row);
        for (var y = 0; y < field.height; y++) {
            var cell = document.createElement('td');
            row.appendChild(cell);
        }
    }
}

function make_field(width, height) {
    var field = Array();
    for (var x = 0; x < width; x++) {
        for (var y = 0; y < height; y++) {
            var cell = {name: 'x'};
            field.push(cell);
        }
    }
    field.width = width;
    field.height = height;
    return field;
}
