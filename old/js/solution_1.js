'use strict'
const log = console.log;
const assert = require('assert');
const assertAndLog = (fun, args, val) => {
    var result = fun.apply(null, args);
    console.log(fun.name, result, args, ' ?= ', val);
    assert.equal(result, val, 'not ok');
    console.log('ok');
}


function solution1(T) {
    let secs = T % (60 * 60);
    let hours = (T - secs) / (60 * 60);
    let msecs = secs % 60;
    let minutes = (secs - msecs) / 60;
    let seconds = msecs % 60;
    return hours + 'h' + minutes + 'm' + seconds + 's';
}

function color3to6(color) {
    let color6 = '#';
    if (color.length === 4) {
        color6 += color[1] + color[1];
        color6 += color[2] + color[2];
        color6 += color[3] + color[3];
    }
    return color6;
}

assert(solution1(0) === '0h0m0s');
assert(solution1(3) === '0h0m3s');
assert(solution1(59) === '0h0m59s');
assert(solution1(61) === '0h1m1s');
assert(solution1(3600) === '1h0m0s');
assert(solution1(3661) === '1h1m1s');
assert(solution1(7200) === '2h0m0s');
assert(solution1(7250) === '2h0m50s');
assert(solution1(7270) === '2h1m10s');
assert(solution1(86399) === '23h59m59s');
//assertAndLog(solution1, 0, '0h0m0s');
log(color3to6('#FA8'));

