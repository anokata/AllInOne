var all = {};
all.a = {f1:1,f2:'fffad',o:{a:1,b:2}};
//all.name;
/*for (all.name in all.a) {
document.writeln(typeof all.a[all.name] +' '+ all.name + ': ' +all.a[all.name]+'<br/>');
}*/
viewall(all.a,'*');
var log= function(a) {document.writeln(a);} ;
var b = document.getElementById('body');
var n = document.createElement('canvas');
b.appendChild(n);
ctx = n.getContext('2d');
ctx.fillRect(0, 0, n.width, n.height);
ctx.fillStyle = "#FFA500";
ctx.strokeStyle = '#67FAF2';
ctx.strokeRect(0, 0, 20, 20);
ctx.fillRect(20, 20, 40, 40);
ctx.clearRect(40, 40, 60, 60);
ctx.strokeStyle = '#FF0000';
ctx.beginPath();
ctx.moveTo(20,40);
ctx.lineTo(40,50);
ctx.lineTo(40,70);
ctx.lineTo(80,70);
ctx.stroke();
var img = new Image(); 
img.onload = function() {
  ctx.drawImage(img,50,50);
  ctx.drawImage(img,150,50);
};
img.src = 'http://pur.orisale.ru/i1.png';
ctx.fillText("[ele]",60,10);
ctx.fillText("[2:]",60,20);

function viewall(a,pre){
  document.writeln('<'+pre +typeof a +' '+a+'><br/>');
  for (var name in a) {
document.writeln(pre + typeof a[name] +' '+ name + ': ' +a[name]+'<br/>');
    if (typeof a[name] === 'object') viewall(a[name],pre+'@ ');
}}


