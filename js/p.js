/*
var log= function(a) {document.writeln(a)} ;
log('aa');
document.writeln('Hello, world!');
var a = "exampleString\u9000\u9999";


log(a);
*/

var example = document.getElementById("example"),
ctx = example.getContext('2d');
ctx.fillRect(0, 0, example.width, example.height);
ctx.fillStyle = "#FFA500";
ctx.strokeStyle = '#B70A02';
ctx.strokeRect(0, 0, 20, 20);
ctx.fillRect(20, 20, 40, 40);
ctx.clearRect(40, 40, 60, 60);

var img = new Image();

