// map Elems - 1 - ground; 2 - wall;
// % of spawn; objcts and it %; отдельно спавнить.
var map, symbols;
var empty = {"spawn": 0.0, 
"name": " ", 
"descritption": "",
"symbol": " ",
"code": 0
};
var tree = {
"spawn": 0.1, 
"name": "bereza tree", 
"descritption": "",
"symbol": "T",
"code": 3
};
var wall = {
"spawn": 0.3, 
"name": "stone wall", 
"descritption": "",
"symbol": "#",
"code": 2
};
var player = {
"name": "player", 
"descritption": "it is you",
"symbol": "@",
"code": 22
};
var objectProtos = [tree,wall,player,empty];
function constructSymbols(objs) {
var symbols = [];
for (var i = 0; i < objs.length; i++) {
  symbols[objs[i].code] = objs[i].symbol;
}
return symbols;
}

var Actors = {};
Actors.player = {"x": 0, "y": 0};

function movePlayer(world, direction) {

switch (direction) {
  case "L": 
    world.map[world.player.x][world.player.y] = '';
    break;
}
}


function genObjcst(obj,map) {
//debugger;
var cells = map.w * map.h;
var objs = Math.round(cells * obj.spawn);
for (var i = 1; i < objs; i ++)
  map[rand(map.w-1)][rand(map.h-1)] = obj.code;
return map;
}

function rand(n) { return Math.round(Math.random()*(n)) }

function genCell(){
return rand(1);
}

function genMap(w,h) {
//noise
var r = Array(w+1).join(1).split('')
      .map(function(){return Array(h+1).join(1).split('')
      .map(function(){return 0;});});
//rooms
r.w = w;
r.h = h;
//gen objcts
//gen trees

r = genObjcst(tree, r);
r = genObjcst(wall, r);

return r;
}

function describe(World) {
//где находишься что видишь, что по сторонам

return "";
}

function viewMapStr(map, symbols) {
var r = "";
for (var i = 0; i < map.length; i++) {
  for (var j = 0; j < map[i].length; j++) 
    r+= symbols[map[i][j]];
r+="\n";
}
return r;
}

function InitPlayer(map) {
map[0][0] = player.code;
return map;
}

////
function arrToStr(a) {
var r = "";
for (var i = 0; i < a.length; i++) {
  for (var j = 0; j < a[i].length; j++) 
    r+= a[i][j].toString();
r+="\n";
}
return r;
}
var a = Array(10).join(1).split('')
      .map(function(){return Array(10).join(1).split('')
      .map(function(){return Math.round(Math.random()) == 0 ? "-" : " "})});
//console.log(arrToStr(a));
///
map = genMap(10,10);
symbols = constructSymbols(objectProtos); //{"1": ".", "2": "#", "0": " ", "3": "T"};
InitPlayer(map);
console.log(viewMapStr(map, symbols));

var world = {"map": map, "actors": Actors, "symbols": symbols};
movePlayer(world);

