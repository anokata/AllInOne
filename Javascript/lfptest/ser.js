var http = require('http');
var fs = require('fs');
var url = require('url');
var util = require('util');
var log_file = fs.createWriteStream('.' + '/debug.log', {flags : 'a'});
var log_stdout = process.stdout;

console.log = function(d) { 
  log_file.write(util.format(d) + '\n');
  log_stdout.write(util.format(d) + '\n');
};

function reqTypeIs(req,type) {
	return (req.url.indexOf(type) != -1)
}
function giveFile(res,filename) {
	if (fs.existsSync(filename)) {
	console.log(req.headers.host , filename);
		data = fs.readFileSync(filename);
		res.writeHead(200, {'Content-Type': 'text/html'});
		res.end(data);
	}
	else 
	{
		//res.writeHead(404, {'Content-Type': 'text/html'});
		res.end('{}');
	}
}

var scoredb = 'score.db';

function caclScore(t,ans) {
	var model = require('./'+t);
	var serverScore = 0;
	for (i in model.qestions){
		serverScore += model.qestions[i].variants[ ans[i] ].points ; 
	}
	console.log(serverScore);
	return serverScore;
}

http.createServer(function (req, res) {
	var purl = url.parse(req.url,true);
//console.log(purl.query.x);
if (reqTypeIs(req,'score')) {
	
	console.log(req.headers.clientdata, req.headers.host, req.headers.referer.substr(req.headers.referer.indexOf('?')+1));
	//write to db
	var test = req.headers.referer.substr(req.headers.referer.indexOf('?')+1);
	var clientscore = JSON.parse(req.headers.clientdata);
	var serverscore = caclScore(test, JSON.parse(clientscore.answers));
	
	if (clientscore.clientScore != serverscore) console.log("<<HACK OR BUG DETECTED!!!>> "+req.headers.host);
	
	fs.appendFileSync(scoredb,JSON.stringify( {Score: clientscore,
		host: req.headers.host , 
	    test: test,
	    serverScore: serverscore
	    })+'\n');

	res.writeHead(200, {'Content-Type': 'text/json'});
	res.end('{}');
	return;
};
if (reqTypeIs(req,'tabataba')) {
	giveFile(res,purl.t)
	return;
};
//logs: get files host, score, diff files not console
var filename = '.'+purl.pathname;
giveFile(res,filename);
//========================================

}).listen(1509);
console.log('[Server started at '+ (new Date()).toLocaleString()+' ]');
