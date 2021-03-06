"use strict";

var consoleEx = require('cli-color');
//require('readline');

//console.log(consoleEx.reset);
process.stdout.write(consoleEx.moveTo(10, 20));
var blank = '';
for (var y = 0; y < consoleEx.height;y++) 
    {
        for (var i = 0; i < consoleEx.width;i++) 
            blank += ' ';
        blank += '\n';
    }
blank = Array(consoleEx.height*consoleEx.width+1).join('x');
console.log(consoleEx.blueBright.bgBlack.bold(blank));
console.log(consoleEx.blueBright.bgBlack.bold('hello node!'));

function clear() {
    process.stdout.write(consoleEx.moveTo(0, 0));
    var blank = Array(consoleEx.height*consoleEx.width+1).join('x');
    console.log(consoleEx.blueBright.bgBlack.bold(blank));
    process.stdout.write(consoleEx.moveTo(0, 0));
}

var styleOne = consoleEx.redBright.bgBlack.bold;


process.stdout.write(consoleEx.moveTo(0, 0));
var keypress = require('keypress'), tty = require('tty');

// make `process.stdin` begin emitting "keypress" events
keypress(process.stdin);
var util = require('util');

// listen for the "keypress" event
process.stdin.on('keypress', function (ch, key) {
    clear()
    console.log(styleOne(util.format('got "keypress"', key)));
    if (key && key.ctrl && key.name == 'c') {
        process.stdin.pause();
  }
});

if (typeof process.stdin.setRawMode == 'function') {
  process.stdin.setRawMode(true);
} else {
  tty.setRawMode(true);
}
process.stdin.resume();

