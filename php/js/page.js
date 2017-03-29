//onLoad 
body = document.body;
function tag(name) {
    d = document.createElement(name);
    document.body.appendChild(d);
    return d;
}

d = tag('div');
d.textContent = 'some';
