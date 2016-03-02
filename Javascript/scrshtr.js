var sin = Math.sin;
var cos = Math.cos;
var exp = Math.exp;
var St = {};
var Do = document;
var Bo = Do.body;
var Ca = Do.createElement("canvas");
var Cn = Ca.getContext('2d');
Bo.appendChild(Ca);
var Wd = 10;
var Ht = 20;
var Tt = Array(Wd+1).join(1).split('').map(function(){return Array(Ht+1).join(1).split('').map(function(){return 0;});});
// 23+76 & 32+67
Tt.AF = function(Fi){};
Ca.width = 300;
Ca.height = 300;
function px(x,y) {Cn.fillRect(x,y,2,2);}
function cl(c) {Cn.fillStyle="#"+c;}
function c(r,g,b) {Cn.fillStyle="#" + r.toString(16) + g.toString(16) + b.toString(16) ;}
function cgrey(a) {c(a,a,a);}
function C1() {
for (var x = 0; x<Ca.width; x++)
for (var y = 0; y<Ca.height; y++) {
cgrey(df2(x,y));
px(x,y);
}}
function C2() {
for (var x = 0; x<Ca.width; x++)
for (var y = 0; y<Ca.height; y++) {
c(d1(x,y),d2(x,y),d3(x,y));
px(x,y);
}}
function sqr(x) {return x*x}
function df(x,y) {
return ( (x>y?x*y+sin(x)*y:cos(x*y)*(exp(x-y))) .toString().substring(2,5)*1).toString(16)
}
function df2(x,y) {
return ( ( sqr(x-Ca.width/2)+sqr(y-Ca.height/2) < 10000 ? x*y+sin(x)*sin(x)*y+cos(y)*cos(y)*x : 255) .toString().substring(2,5)*1)*1
}
function d1(x,y) {
return ( (x>y?x*y+sin(x)*y:cos(x*y)*(exp(x-y))) .toString().substring(2,5)*1)*1
}
function d2(x,y) {
return ( (x>y?x*y+sin(x)*y:cos(x*y)*(exp(x-y))) .toString().substring(5,8)*1)*1
}
function d3(x,y) {
return ( (x>y?x*y-sin(x)*y:cos(x*y)*(exp(x-y))) .toString().substring(3,6)*1)*1
}

//smoth
function C3() {
for (var x = 0; x<Ca.width; x++)
for (var y = 0; y<Ca.height; y++) {
c((df2(x,y)+df2(x+1,y)+df2(x,y+1)+df2(x+1,y+1)+df2(x-1,y)+df2(x,y-1)+df2(x-1,y-1)+df2(x+1,y-1)+df2(x-1,y+1))/9
,(df2(x,y)+df2(x+1,y)+df2(x,y+1)+df2(x+1,y+1)+df2(x-1,y)+df2(x,y-1)+df2(x-1,y-1)+df2(x+1,y-1)+df2(x-1,y+1))/9
,(df2(x,y)+df2(x+1,y)+df2(x,y+1)+df2(x+1,y+1)+df2(x-1,y)+df2(x,y-1)+df2(x-1,y-1)+df2(x+1,y-1)+df2(x-1,y+1))/9);  
px(x,y);
}}

function circle(x,y,cx,cy,R) {
return (sqr(x-cx)+sqr(y-cy) < R*R ? 0:255);
}

function fourCirc(x,y) {
return ( (x<Ca.width/2 ? 
      (y<Ca.height/2? circle(x, y, Ca.width/2, Ca.height/2, 100)
        :255)
      :(y<Ca.height/2? 255
        :255)))
 .toString(16)
}
function C4c() {
for (var x = 0; x<Ca.width; x++)
for (var y = 0; y<Ca.height; y++) {
c(fourCirc(x,y),fourCirc(x,y),fourCirc(x,y));
px(x,y);
}}
//C4c();

//arc?
function randomColor() {c(Math.round((Math.random()*255)), Math.round((Math.random()*255)), Math.round((Math.random()*255)));}
function pie(x,y,s,e) {
Cn.beginPath();
Cn.arc(x,y,R,s*Math.PI*2,e*Math.PI*2); 
Cn.lineTo(x,y);
Cn.fill();
Cn.closePath();
}
var cx = 100; var cy = 100; var R = 100;
cl("000");
pie(0,0,0,0.25); 
pie(R*2,0,0.25,0.5); 
pie(R*2,R*2,0.5,0.75); 
pie(0,R*2,0.75,1); 
//function star(x,y,r) {

function randpaint() {
for (var i = 0; i < 20; i++)
for (var j = 0; j < 20; j++) {

}
}
