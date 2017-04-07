<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
	"http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<title></title>
		<style>
		ul {
		background-color: aliceblue;
        border-width: 2px;
        border-style: groove;
        width: 40%;
        left: 30%;
        position: relative;
        border-radius: 6px;
            }
        li.selected {
        background-color: azure;
        }
        #addControl {
        position: relative;
        left: 30%;
        }
        input {
        width: 43%;
        }
        
        #modalWindow {
     visibility: hidden;
     position: fixed;
     left: 0;
     top: 0;
     width: 100%;
     height: 100%;
     text-align:center;
     z-index: 200;
     background-color: black;
     opacity:0.5;
    }

    #modalWindow div {
     width:30%;
     margin: 30% auto;
     background-color: #fff;
     border:1px solid #000;
     padding:1%;
     text-align:center;
    }
		
		</style>
		<script>
		var serverUrl =location.origin+(location.pathname.substr(0,location.pathname.indexOf("/list")+1));
		
function showModalWindow(){
el = document.getElementById("modalWindow");
el.style.visibility = (el.style.visibility == "visible") ? "hidden" : "visible";
}

function closeModalWindow() {
     document.getElementById("modalWindow").style.visibility = 'hidden';
}

function closeModalWindowYes() {
     closeModalWindow();
     if (document._.dialog.currentElem) {
        deleteItem(document._.dialog.currentElem);
        document._.dialog.currentElem = undefined;
        }
}


        function ajaxSend(data) {
            var req = new XMLHttpRequest();
                req.open("GET",serverUrl+data,false);
                //req.setRequestHeader("clientID",game.clientID);
                req.send(null);
            return JSON.parse(req.responseText);
        }
        function createButton(where,onclk) {
            var but = document.createElement('div');
            with(but){
                textContent = '';
                with(style){
                    backgroundColor='#ad0';
                    width = '30px';
                    height = '20px';
                    position ='relative';
                    left = '0px';
                    top = '0px';
                    cursor = 'default';
                    display = 'inline-block';
                    textAlign = 'center';
                    borderWidth = '1px';
                    borderStyle = 'outset';
                    borderRadius = '5px';
            }}
            where.appendChild(but);
            but.onmousedown = function(e) { but.style.backgroundColor='#fd0';e.preventDefault(); };
            but.onmouseup = function(e) { but.style.backgroundColor='#ad0'; };
            but.ondblclick = function(e) {};
            but.onclick = onclk;
            return but;
        }
        
        function getElemIndex(a,e) {
            for (var i = 0; i<a.length; i++)
            if (a[i] == e) return i;
            return -1;
        }
        
        function deleteItem(e) {
            var listElems = document.getElementsByTagName('li');
            e = e.target.parentNode.parentNode;
            //var index = Number(e.id.substr(e.id.indexOf("_")+1));
            var index = getElemIndex(listElems, e);
            ajaxSend("del.php?what="+index);
            e.remove();
            //listElems[index].remove();
            document._.elemsCount--;
            
        }
        
        function selectItemFun (e) { 
                    e.target.classList.add('selected');
                };
        function unselectItemFun(e) { 
                    e.target.classList.remove('selected');
                };
        function addListItem(e) {
        e.buttonDiv = document.createElement('div');
                with( e.buttonDiv.style) {
                    textAlign = 'right';
                    display = 'inline-block';
                    position = 'absolute';
                    right = '10px';
                }
                e.appendChild(e.buttonDiv);
                e.buttonDel = createButton(e.buttonDiv, YNdeleteItem);
                e.buttonDel.id = "buttonDel_"+document._.elemsCount++;
                e.buttonDel.textContent = 'del';
                e.onmouseenter = selectItemFun;
                e.onmouseleave = unselectItemFun;
        }
        
        function YNdeleteItem(e) {
            document._.dialog.currentElem = e;
            showModalWindow();
        }


		window.onload = function () {
            //document.getElementsByTagName('li').onmousemove = function (e) {
            document._ = {};
            document._.dialog = {};
            var listElems = document.getElementsByTagName('li');
            for (var i = 0; i < listElems.length; i++) {
                document._.elemsCount = i;
                addListItem(listElems[i]);
            }
            
            var addButton = createButton(document.getElementById("addButton"), function (e) {
                    var newElem = ajaxSend("add.php?what="+document.getElementById("addText").value).newElem;
                    var list = document.getElementsByTagName('ul')[0];
                    var newItem = document.createElement('li');
                    list.appendChild(newItem);
                    newItem.textContent = newElem;
                    addListItem(newItem);
                } );
            addButton.textContent = "add";
            
            var testModal = createButton(document.getElementById("addButton"), showModalWindow);
            testModal.textContent = "show";
            document.getElementById("closeButton").onclick=closeModalWindow;
            document.getElementById("closeButtonYes").onclick=closeModalWindowYes;
		}
		
		function createModalDialoge() {
		
		}
		</script>
	</head>
	<body>
		<?php 
		
		function printArray($a) {
			for ($i = 0; $i<count($a); $i++)
                echo $a[$i], "<br/>";
		};
		function printArrayList($a) {
            echo "<ul>";
			for ($i = 0; $i<count($a); $i++)
                echo "<li>", $a[$i], "</li>";
            echo "</ul>";
            echo "<br/>";
		};		
		
		// strore list in file:
		// one page-query.php for get / one ajax for add
		$fileName =  "storage.dat";
		$data = file($fileName);
		printArrayList($data);
		
		//$what=$_REQUEST["what"];

		
		 ?>
		 <div id="addControl"><input type='text' id="addText"></input><div id="addButton"/></div>
		 
		 <div id="modalWindow">
		 <div>
		 Really delete!?
		 <br/>
		 <input type='button' id="closeButtonYes" value="Yes"></input>
		 <input type='button' id="closeButton" value="No"></input>
		 </div>
		 
	</body>
</html>
