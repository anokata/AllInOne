$(document).ready(function() {
var a = {}; //мой домик. буду тут всё складировать.
a.serverUrl = 'http://alexeidelejov.krista.ru:1509/';//отсюда мы родом
a.serverUrl2 = location.host+'/';//а точнее отсюда
a.test = location.href.substr(location.href.indexOf('?')+1);//что там нам дали - мы хотим забрать.
// если там пусто
if (location.href.indexOf('?') == -1) {
	document.write('don\'t do that, please');
};

function ajaxSend(data) {
    var req = new XMLHttpRequest();
        req.open("GET",a.serverUrl+data,false);
        //req.setRequestHeader("clientID",game.clientID);
        req.send(null);
    return JSON.parse(req.responseText);
}
function ajaxSendData(url,data) {
    var req = new XMLHttpRequest();
        req.open("GET",a.serverUrl+url,false);
        req.setRequestHeader("clientdata",JSON.stringify(data));
        req.send(null);
    return JSON.parse(req.responseText);
}

a.model = ajaxSend(a.test);
//make it real!
function makeRadioOne(text,to,id, gid) {
	var cont = document.createElement('div');
	var inp = document.createElement('input');
	inp.type = 'radio';
	inp.title = 'aga';
	inp.id = id;
	inp.name = 'grp'+gid;
	var lab = document.createElement('label');
	lab.for = id;
	lab.textContent = text;
	lab.className = 'variantTextStyle';
	//cont.style = a.styleR;
	cont.className = 'radioStyle';
	cont.appendChild(inp);
	cont.appendChild(lab);
	to.appendChild(cont);
}
//makeRadioOne('rad01',document.body);
function makeQuestion(q,to,n) {
	var lab = document.createElement('div');
	lab.textContent = q.text;
	lab.className = 'qtextStyle';
	to.appendChild(lab);
	for (i in q.variants)
		makeRadioOne(q.variants[i].text , to , 'id'+i, n);
		
}

//edit with name


for (i in a.model.qestions) {
	var cont = document.createElement('div');
	cont.className = 'questionStyle';
	makeQuestion(a.model.qestions[i] , cont , i);
	document.body.appendChild(cont);
	
}
//button send
//fill new model answer, send, view result
	a.button = document.createElement('input');
	a.button.type = 'button';
	a.button.value = 'Send';
document.body.appendChild(a.button);
a.button.onclick = function () {
	var ans = $('input[type=radio]:checked');
	if (a.model.qestions.length != ans.length)
		alert('not all: ')
	else {
		ans = $('input[type=radio]:checked').map(function(i,e) { var id = $(e).attr('id'); return Number(id.substr(2)); }).toArray();
		//JSON.stringif ajax
		var clientScore = 0;
		for (i in a.model.qestions)
			clientScore += a.model.qestions[i].variants[ ans[i] ].points ; 
		console.log(clientScore, ans);
		
		//calc max score!
		
		$('body > *').remove();
		$('body').text(clientScore + ' points, is ' + (100*clientScore/a.model.maxscore).toString().substr(0,6)+'%');
		$('body').append($('<div>').attr('class', 'score').text(clientScore + ' points, is ' + (100*clientScore/a.model.maxscore).toString().substr(0,6)+'%'));
		
		ajaxSendData('score', {clientScore: clientScore, 
			answers: JSON.stringify(ans)});
		
	}
	
	//refresh? show score page "/score?"
}















});
