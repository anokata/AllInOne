function n(a) {return document.createElement(a);}
function d() {return n('div');}
var mainDiv = document.createElement("div");
document.body.appendChild(mainDiv);
var mainTable = n("table");
var cellQ = 30;
makeUnselected(mainTable);
mainTable.tds = [];
mainDiv.appendChild(mainTable);
mainTable.style["border-spacing"] = "0px";
//create board
for (var x = 1; x <= 8; x++) {
  var tr = n('tr');
  makeUnselected(tr);
  mainTable.appendChild(tr);
  for (var y = 1; y <= 8; y++) {
  if (y == 1) mainTable.tds[x-1] = [];
    var td = n('td');
    tr.appendChild(td);
    td.x = x;
    td.y = y;
    td.isEmpty = true;
    mainTable.tds[x-1][y-1] = td;
    with (td.style) {
      width = cellQ + 'px';
      height = cellQ + 'px';
      backgroundColor = (x+y) % 2 == 0 ? 'burlywood' : 'antiquewhite';
    }
    makeUnselected(td);
  }  
}

mainTable.onmousedown = function (e) {
      var x = Math.floor((e.clientX - cellQ/2) / cellQ) - 0;
      var y = Math.floor((e.clientY - cellQ/2) / cellQ) - 0;
      console.log( x,y);
    var cell = e.target;
    var x = cell.x;
    var y = cell.y;
    if (!cell.isEmpty) {
      mainTable.dragged = mainTable.tds[x][y].piece;
      mainTable.tds[x][y].piece.style.color = "red";
      mainTable.tds[x][y].piece.drag = true;
    }
}
mainTable.onmouseup = function (e) {
      mainTable.dragged.style.color = mainTable.dragged.isBlack ? 'black' : 'white';
      mainTable.dragged.drag = false;
      mainTable.dragged.style.position = "inherit";
      var x = Math.floor((e.clientX - cellQ/2) / cellQ) - 0;
      var y = Math.floor((e.clientY - cellQ/2) / cellQ) - 0;
      console.log(x,y);
      mainTable.tds[x][y].appendChild(mainTable.dragged);
}
mainTable.onmousemove = function (e) {
//console.log(e);
  if (mainTable.dragged && mainTable.dragged.drag) {
    with (mainTable.dragged.style) {
      position = "absolute";
      top = (e.clientY - cellQ/2) + "px";
      left = (e.clientX - cellQ/2) + "px";
    }
  }
}

function makeUnselected(a) {
a.style["-webkit-touch-callout"] = "none";
a.style["-webkit-user-select"] = "none";
a.style["-khtml-user-select"] = "none";
a.style["-moz-user-select"] = "none";
a.style["-ms-user-select"] = "none";
a.style["user-select"] = "none";
}

function createPiece(isBlack, sym, x, y) {
  var piece = d();
    with (piece.style) {
      fontWeight = 'bold';
      color = isBlack ? 'black' : 'white';
      fontSize = (cellQ - 2) + 'px';
      cursor = 'default';
    }
  piece.textContent = sym;
  piece.x = x;
  piece.y = y;
  piece.drag = false;
  piece.isBlack = isBlack;
  makeUnselected(piece);
  mainTable.tds[x][y].appendChild(piece);
  mainTable.tds[x][y].piece = piece;
  if (isBlack) {
    blackPieces.push(piece);
  } else {
    whitePieces.push(piece);
  }
}

var whitePieces = [];
// king queen rook bishop knight pawn
var blackPieces = [];
//create pawns
for (var p = 1; p <= 8; p++) {
  createPiece(true,"♟",1,p-1);
}
for (var p = 1; p <= 8; p++) {
  createPiece(false,"♟",6,p-1);
}

//create rooks kings knights bishops
createPiece(true,"♜",0,0);
createPiece(true,"♜",0,7);
createPiece(false,"♜",7,0);
createPiece(false,"♜",7,7);
createPiece(true,"♚",0,3);
createPiece(false,"♚",7,3);
createPiece(true,"♛",0,4);
createPiece(false,"♛",7,4);
createPiece(true,"♞",0,1);
createPiece(true,"♞",0,6);
createPiece(false,"♞",7,1);
createPiece(false,"♞",7,6);
createPiece(true,"♝",0,2);
createPiece(true,"♝",0,5);
createPiece(false,"♝",7,2);
createPiece(false,"♝",7,5);



