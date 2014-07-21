var all = {};
all.a = {f1:1,f2:'fffad',o:{a:1,b:2}};
//viewall(all.a,'*');
var log= function(a) {document.writeln(a);} ;
function viewall(a,pre){
  document.writeln('<'+pre +typeof a +' '+a+'><br/>');
  for (var name in a) {
document.writeln(pre + typeof a[name] +' '+ name + ': ' +a[name]+'<br/>');
    if (typeof a[name] === 'object') viewall(a[name],pre+'@ ');
}}
///=====
var b = document.getElementById('body');
var n = document.createElement('canvas');
n.height='300';n.width='400';
b.appendChild(n);
ctx = n.getContext('2d');
ctx.fillRect(0, 0, n.width, n.height);
ctx.fillStyle = "#FFA500";
ctx.strokeStyle = '#FFA500';
ctx.clearRect(0, n.height-10, n.width, 5);
ctx.fillRect(n.width-20, 0, 20, n.height);
ctx.fillStyle = "#909090";
//for (var i = 0;i<13;i++) {ctx.fillRect(i*30, n.height-5, 15, 5);}

ctx.strokeRect(5, 2, 45, 50);
ctx.fillStyle = "#FFA500";
ctx.fillText("[ele]",10,15);
ctx.fillText("[2:]",10,27);

//drawlist([1,2],5,70);
drawListInFrame(new Array('adfa','g','g'),15,70);
drawListInFrame(new Array('text','(1)with','function on load() #)$(*@'),100,170,140);

function drawlist(a,x,y){
  for (var i=0;i<a.length;i++) {
    ctx.fillText(a[i],x,y+i*12);//font size but not 12
  }
}
function drawListInFrame(a,x,y,w){
  drawlist(a,x,y);

  ctx.strokeRect(x-5, y-13, w, 12*a.length+13);
}
function maxWidthInList(a){
  var m=0;
  for (var i =0;i<a.length;i++){
    if (m<a[i].length) m=a[i].length;
  }
  return m;
}



