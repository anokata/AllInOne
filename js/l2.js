function getChar(event) {
  if (event.which == null) {  // IE
    if (event.keyCode < 32) return null; // спец. символ
    return String.fromCharCode(event.keyCode);
  }
  if (event.which!==0 && event.charCode!==0) { // все кроме IE
    if (event.which < 32) return null; // спец. символ
    return String.fromCharCode(event.which); // остальные
  }
  return null; // спец. символ
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
//for (var i = 0;i<13;i++) {ctx.fillRect(i*30, n.height-5, 15, 5);}


var a = new Array('text','(1)with','function on load() #)$(*@');

//log(ctx.measureText(a[maxInList(a)]).width);
//drawListInFrame(new Array('adfa','\u2503','g'),15,170);
//drawListInFrame(a,10,30);

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
//log(maxInList.toSource());

var A = {
    x:100,
    y:100,
    h:11,
    w:11,
    L:100, //life
    spd:5,
    f:11,
    vy:0,
    g:-5,
    actmov: ['g'],
    draw: function () {
        ctx.save();
        ctx.fillStyle = "#fff";
        ctx.fillRect(this.x,this.y,this.h,this.w);
        ctx.fillStyle = "#f2f";
        ctx.font = "Bold "+this.f+"pt Dejavu Mono Sans";
        ctx.fillText('a',this.x,this.y+this.f);
        ctx.fillStyle = "#fff";
        ctx.strokeStyle = '#fff';
        
        ctx.font = "8pt Dejavu Mono Sans";
        ctx.fillText(this.actmov.concat(),this.x+10,this.y+10);  
        ctx.fillText(this.L,this.x,this.y-10);  
       
        
        ctx.restore();
        
    },
    process: function () {
        for(var a=0;a<this.actmov.length;a++){
            this.move(this.actmov[a]);
            
        }
        if (this.mayBeAt(this.x,this.y-this.vy)) 
        this.y-=this.vy;
            
    },
        mayBeAt: function (x,y) {
            for (var i=0; i<world.blocks.length;i++){
                //alert((this.intersect(world.blocks[i],x,y)));
                if (this.intersect(world.blocks[i],x,y)) return false;
            }
            return true;
    },
  intersect: function (b,x,y) {
            //alert(' bx'+b.x+'x:'+x+' bw'+b.w+'| by'+b.y+' y:'+y+' bh'+b.h+'| w'+this.w+' h'+this.h);
            return (x>b.x && x<b.x+b.w && y>b.y && y<b.y+b.h) || 
                ((x+this.w)>b.x && (x+this.w)<b.x+b.w && y>b.y && y<b.y+b.h) || 
                ((x+this.w)>b.x && (x+this.w)<b.x+b.w && (y+this.h)>b.y && (y+this.h)<b.y+b.h) || 
                (x>b.x && x<b.x+b.w && (y+this.h)>b.y && (y+this.h)<b.y+b.h);
    },
    moveat: function (dir) {
        //if (this.actmov.indexOf(dir)===-1)
            this.actmov.push(dir);
    },
    stop: function () {
            this.actmov = [];
    },
    stopat: function (d) {
            this.actmov.splice(this.actmov.indexOf(d),1);
    },
    move: function (dir) {
        switch (dir) {
            case 'u': 
                if (this.mayBeAt(this.x,this.y-this.spd))
                 this.y-=this.spd; 
            break;
            case 'd': 
            if (this.mayBeAt(this.x,this.y+this.spd)) this.y+=this.spd;  break;
            case 'l': 
            if (this.mayBeAt(this.x-this.spd,this.y)) this.x-=this.spd; break;
            case 'r': 
            if (this.mayBeAt(this.x+this.spd,this.y)) this.x+=this.spd; break;
            case 'j': this.vy=20;
            this.actmov.splice(this.actmov.indexOf('j'),1);
             break;
            //gravity
            case 'g': 
            if (this.vy >= this.g)
                this.vy+=this.g; break;
        }
    }

    };

var menu = {
  elems: ['start','\u1002pt','h\u1001lp'],
  x: 10,
  y: 30,
  selected: 0,
  print: function() {
    drawStart();
    drawListInFrameSel(menu.elems , menu.x,menu.y,menu.selected);
   
    ctx.strokeStyle = "#35A";
    ctx.beginPath();
    ctx.arc(150,50,30,0,Math.PI/2,false);
    ctx.closePath();
    ctx.stroke();
    ctx.fill();
    ctx.beginPath();
    ctx.arcTo(150,20,150,70,50);
    ctx.fill();
    
    A.draw();
    
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
//menu.elems[3]='new';
menu.print();

var world = {
    down: [],
    blocks: [],
    
    maypass: function () {
            
            return false;
    },
    
    repaint: function() {
        ctx.fillStyle = "#000";
        ctx.fillRect(0, 0, n.width, n.height);
        A.draw();
        for(var i=0;i<this.blocks.length;i++)
            this.blocks[i].draw();
    },
    
    process: function() {
        A.process();
    },
    
    keydown: function (e) {
    e = e || window.event;
    //alert(e.keyCode);
    if (! world.down[e.keyCode]) 
        {switch (e.keyCode){
        case 39: A.moveat('r'); break;
        case 37: A.moveat('l'); break;
        case 38: A.moveat('u'); break;
        case 40: A.moveat('d'); break;
        case 74: //alert('J');
            A.moveat('j'); break;
        default:  break;
        
        }}
        world.down[e.keyCode] = true;
        //world.process();
        //world.repaint();
    },
    keyup: function (e) {
    e = e || window.event;
    world.down[e.keyCode] = false;
        switch (e.keyCode){
        case 39: A.stopat('r'); break;
        case 37: A.stopat('l'); break;
        case 38: A.stopat('u'); break;
        case 40: A.stopat('d'); break; 
        //case 74: A.stopat('j'); break; 
        default:  break;
        
        }
        world.process();
        world.repaint();
        },
    atTimer: function () {
        world.process();
        world.repaint();
    }
};

function GObj() {
    this.x=Math.floor(Math.random()*130);
    this.y=240;
    this.w=20;
    this.h=20;
    this.pass=false;
    this.color='#f00';
    this.fcolor='#777';
    this.char='Block';
    this.f = "9 pt Dejavu Mono Sans";
    this.draw = function () {
        ctx.save();
          
        //ctx.scale(0.6,0.6);
        ctx.fillStyle = this.color;
        ctx.fillRect(this.x,this.y,this.w,this.h);
        ctx.fillStyle = this.fcolor;
        ctx.font = this.f;
        
        //ctx.fillText(this.char,this.x,this.y);
        
        ctx.restore();    
    };
}
var block = new GObj();
block.x=0; block.y=250; block.w = 300; block.h = 20; block.color = '#862';
world.blocks.push(block);
block = new GObj(); block.y=160;
world.blocks.push(block);
block = new GObj(); block.y=180;
world.blocks.push(block);
block = new GObj(); block.y=100;
world.blocks.push(block);
block = new GObj(); block.y=120;
world.blocks.push(block);

b.onclick= function () {menu.add('a');menu.print();};
////b.onkeypress = menu.keyhandler;
//b.addEventListener('keypress',menu.keyhandler,false);
b.addEventListener('keydown',world.keydown,false);
b.addEventListener('keyup',world.keyup,false);
//var timerId = setInterval(menu.print,1000);
var timer2 = setInterval(world.atTimer,50);
//ctx.translate(75,75);

/*
 * game: A - main char. всё остальное тоже буквы и слова. всё из слов и символов. оружие это буквы от z,y,x...
 * gravity - G vv. press A make 'a' bigger and destroy . O - circle Shield
 */




