// ��� � ���. ������ ����  tsc.cmd t31nrw.ts
//ok
var Main;
(function (Main) {
    var HTMLElemCell = (function () {
        function HTMLElemCell() {
        }
        return HTMLElemCell;
    })();
    var static = (function () {
        function static() {
        }
        return static;
    })();
    Main.static = static;
    Main;
    {
        gs = {};
        main();
        {
            var gameState = {};
            init(gameState);
            game(gameState);
            finit(gameState);
            gs = gameState;
        }
    }
    function log(msg) {
        console.log(msg);
    }
    function createElem(elemname) {
        return document.createElement(elemname);
    }
    function ND() {
        return createElem('div');
    }
    //ok
    function makeArray2D(w, h, initVal) {
        return Array(w + 1).join('0').split('')
            .map(function () {
            return Array(h + 1).join('1').split('')
                .map(function () { return initVal; });
        });
    }
    //blank: 
    //todo
    //function () {}
    //--------------------------------------------------
    var gs = {};
    //todo
    function main() {
        var gameState = {};
        init(gameState);
        game(gameState);
        finit(gameState);
        gs = gameState;
    }
    Main.main = main;
    //todo
    function init(gs) {
        makeGameField();
        gs.fh = 10;
        gs.fw = 10;
        gs.field = makeArray2D(gs.fh, gs.fw, 0);
        for (var x = 0; x < gs.fh; x++)
            for (var y = 0; y < gs.fw; y++)
                gs.field[x][y] = Math.round(Math.random() * 5);
        makeInterface(gs);
        makeField(gs);
        updateField(gs);
    }
    //todo
    function game(gs) {
        updateField(gs);
    }
    //todo
    function finit(gs) { }
    //todo
    function makeGameField() { }
    //todo
    function makeInterface(gs) {
        var mainDiv = ND();
        gs.width = 100;
        gs.height = 100;
        document.body.appendChild(mainDiv);
        gs.mainDiv = mainDiv;
        mainDiv.style.width = gs.width + 'px';
        mainDiv.style.height = gs.height + 'px';
        mainDiv.style.backgroundColor = '#ccc';
    }
    //todo
    function updateField(gs) {
        //makeField(gs);
    }
    //todo
    function makeBlock(color) {
    }
    //todo
    function makeField(gs) {
        gs.colors = ["#fff", "#222", "#444", "#666", "#888", "#bbb", "#eee", "#000", "#ddd", "#aaa"];
        for (var x = 0; x < gs.fh; x++)
            for (var y = 0; y < gs.fw; y++) {
                var cellWH = gs.width / gs.fw;
                var cell = new HTMLElemCell();
                cell.cell = ND();
                gs.mainDiv.appendChild(cell.cell);
                cell.cell.style.width = cellWH + 'px';
                cell.cell.style.height = cellWH + 'px';
                cell.cell.style.backgroundColor = gs.colors[gs.field[x][y]];
                cell.cell.style.cssFloat = 'left';
                cell.x = x;
                cell.y = y;
                cell.isEmpty = gs.field[x][y] == 0 ? true : false;
                cell.cell.onclick = function (e) {
                    blockClick(gs, e.target, cell);
                };
            }
    }
    function blockClick(gs, block, ths) {
        gs.field[ths.x][ths.y] = 0;
        block.style.backgroundColor = gs.colors[0];
        ths.isEmpty = true;
    }
})(Main || (Main = {}));
Main.main();
