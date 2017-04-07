//first
document.cookie = '2008-01-01';
//second
//TOdo!!! for other all!!!: page with frame and edit with source to frame and button script exec
//or ajax send fake

var newElem = function (x) {return document.createElement(x)};
function createButton(where,onclk) {
    var but = newElem('div');
    with(but){
        textContent = '***';
        with(style){
            backgroundColor='#ad0';
            width = '50px';
            height = '20px';
            position ='relative';
            left = '0px';
            top = '0px';
            cursor = 'default';
    }}
    where.appendChild(but);
    but.onmousedown = function(e) { but.style.backgroundColor='#fd0';e.preventDefault(); };
    but.onmouseup = function(e) { but.style.backgroundColor='#ad0'; };
    but.ondblclick = function(e) {};
    but.onclick = onclk;
    return but;
};

function next(d){
var day = (Number(d.substr(5,2))+1);
day = day>9?(day.toString()) : '0'+day;
return (d.substr(0,5)+ day +'-01');
}
function nexty(d){
var y = (Number(d.substr(0,4))+1);
return (y +'-01-01');
}
var body = document.getElementsByTagName('body')[0];
a=document.getElementById('date');

b = createButton(body, function() {
a.value=next(document.cookie);
x = document.getElementsByName('addPeriod')[0];
x.checked = true;
z = document.getElementsByName('datamart')[0];
z.selectedIndex =45;
document.cookie = a.value;
});
with(b.style) {
backgroundColor='#0f0';
left = '460px';
top= '50px';
cursor= 'default';
position= 'absolute';
}
c = createButton(body, function() {
x = document.getElementsByName('addPeriod')[0];
x.checked = true;
a.value=nexty(document.cookie);
z = document.getElementsByName('datamart')[0];
z.selectedIndex =45;
document.cookie = a.value;
});
with(c.style) {
backgroundColor='#00f';
left = '490px';	
top= '50px';
cursor= 'default';
position= 'absolute';
}
a.value = document.cookie;
x = document.getElementsByName('addPeriod')[0];
x.checked = true;
z = document.getElementsByName('datamart')[0];
z.selectedIndex =45;

