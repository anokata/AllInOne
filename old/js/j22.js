function getChar(event) {
  if (event.which == null) {  
    if (event.keyCode < 32) return null; 
    return String.fromCharCode(event.keyCode);
  }
  if (event.which!==0 && event.charCode!==0) { 
    if (event.which < 32) return null; 
    return String.fromCharCode(event.which);
  }
  return null; 
}
var all = {};
all.a = {f1:1,f2:'fffad',o:{a:1,b:2}};
//viewall(all.a,'*');
//var log= function(a) {document.writeln(a);} ;
function viewall(a,pre){
  //document.writeln('<'+pre +typeof a +' '+a+'><br/>');
  for (var name in a) {
//document.writeln(pre + typeof a[name] +' '+ name + ': ' +a[name]+'<br/>');
    if (typeof a[name] === 'object') viewall(a[name],pre+'@ ');
}}
///=====
var b = document.getElementById('body');
var n = document.createElement('canvas');
n.height='300';n.width='400';
b.appendChild(n);
ctx = n.getContext('2d');
var now = new Date();

function drawInit(){
  ctx.fillStyle = "#FFA500";
  ctx.strokeStyle = '#FFA500';
  ctx.fillStyle = "#909090";
  all.fontsize = 15;
ctx.font = "bold "+all.fontsize+"pt Dejavu Sans Mono";
ctx.fillStyle = "#FFA500";
ctx.fillStyle = "#09E";
ctx.strokeStyle = '#09E';
ctx.lineWidth =2;
}
function drawStart(){
  ctx.fillStyle = "#000";
  ctx.fillRect(0, 0, n.width, n.height);
  ctx.fillStyle = "#FFA500";
  ctx.clearRect(0, n.height-10, n.width, 5);
  ctx.fillRect(n.width-20, 0, 20, n.height);
  ctx.fillStyle = "#09E";
  
  now = new Date();
  var c=ctx.fillStyle;
  ctx.fillStyle = '#0D9';
  var f=ctx.font;
  ctx.font = "9pt Dejavu Sans";
  ctx.fillText(now.toLocaleString(),10,285);
  ctx.font=f;
  ctx.fillStyle = c;
}

drawInit();

var a = new Array('text','(1)with','function on load() #)$(*@');


function drawlist(a,x,y){
  for (var i=0;i<a.length;i++) {
    ctx.fillText(a[i],x,y+i*(all.fontsize+5));//font size but not 12
  }
}
function drawListInFrame(a,x,y){
  drawlist(a,x,y);

  ctx.strokeRect(x-5, y-(all.fontsize+5), ctx.measureText(a[maxInList(a)]).width+20, (all.fontsize+5)*a.length+13);
}
function maxInList(a){
  var m=0;
  for (var i =0;i<a.length;i++){
    if (a[m].length<a[i].length) m=i;
  }
  return m;
}
function drawlistselected(a,x,y,sindex){
  for (var i=0;i<sindex;i++) {
    ctx.fillText(a[i],x,y+i*(all.fontsize+5));//font size but not 12
  }
    ctx.fillStyle = "#3EF";
    ctx.fillText(a[sindex],x,y+sindex*(all.fontsize+5));
    ctx.fillStyle = "#08D";
    for ( i=sindex+1;i<a.length;i++) {
    ctx.fillText(a[i],x,y+i*(all.fontsize+5));//font size but not 12
  }
}
function drawListInFrameSel(a,x,y,s){
  drawlistselected(a,x,y,s);
  ctx.strokeRect(x-5, y-(all.fontsize+5), ctx.measureText(a[maxInList(a)]).width+20, (all.fontsize+5)*a.length+13);
}


var menu = {
  elems: ['menu list','key [i] - up','key [k] - down'],
  x: 10,
  y: 30,
  selected: 0,
  print: function() {
    drawStart();
    drawListInFrameSel(menu.elems , menu.x,menu.y,menu.selected);

    
  },
  add: function(a) {this.elems[this.elems.length]=a;},
  keyhandler: function (e) {
    e = e || window.event;
    //var char = getChar(e || window.event); 
    //menu.add(getChar(e));
    switch (getChar(e)) {
      case 'i': if (menu.selected>0) menu.selected--;    
        else menu.selected = menu.elems.length-1;
        break;
      case 'k': if (menu.selected<menu.elems.length-1) menu.selected++; else menu.selected=0; 
        break;
      case 'g': alert('gaa!');  break;
      default: break;
        
    }

    
    menu.print();
    return false;
  }
};

menu.print();

b.onclick= function () {menu.add('a');menu.print();};

b.addEventListener('keypress',menu.keyhandler,false);

var timerId = setInterval(menu.print,1000);




