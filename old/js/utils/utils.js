/*var View; // View тут все видимые элементы
var Data; // Model тут все данные
var Proc; // Controller тут все обработчики
//Proc.dom.

Proc.newElem = function (x) {return document.createElement(x)};
Proc.newText = function (x) {return document.createTextNode(x)};
View.body = document.getElementsByTagName('body')[0];
Proc.addToBody = function (x) {return View.body.appendChild(x)};
Proc.addDiv = function () {var z = Proc.newElem('div'); Proc.addToBody(z); return z};
View.doc = document;
*/
var newElem = function (x) {return document.createElement(x)};
var body = document.getElementsByTagName('body')[0];
var addToBody = function (x) {return body.appendChild(x)};
var div = function () {var z = newElem('div'); addToBody(z); return z};

function createList(to) {
    var list = newElem('div');
    with (list.style) {
        width = '80px';
        height = '50px';
        backgroundColor = '#eee';
        borderWidth = '1px';
        borderColor = 'black';
        borderStyle = 'solid';
    }
    to.appendChild(list);
    list.items = [];
    list.addListItem = function (text) {
        //item: {block:div, text:}
        var itemdiv = newElem('div');
        this.items.push( {block:itemdiv, text: text, selected: false} );
        list.appendChild(itemdiv);
        itemdiv.textContent = text;
        
        with (itemdiv.style) {
			backgroundColor = (this.items.length%2==0 ?'#eee':'#ccc');
        }
    }
    return list;
}
