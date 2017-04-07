'use strict';

const http = require('http');
const fs = require('fs');
const url = require('url');
const exec = require('child_process').exec;

function toGGCoord2(c) {
  return (String.fromCharCode(Number(c) + 97));
}

function toSgf(t) {
  let s = '';
  for (let i = 0; i < t.length; i += 1) {
    s += `;${t[i].color}[${toGGCoord2(t[i].x)}${toGGCoord2(t[i].y)}]`;
  }
  return s;
}

function numberFormat2(a) {
  return a > 9 ? (a.toString()) : `0${a}`;
}

function now() {
  const d = new Date();
  return `${d.getFullYear()}-${numberFormat2(d.getMonth())}-${numberFormat2(d.getDay())}`;
}

function Cell(stone, dame) {
  this.stone = stone;
  this.dame = dame;
  this.existStone = function exst() {
    return this.stone !== 'n';
  };
  this.group = 0;
}

function Turn(x, y, color, eated) {
  this.x = x;
  this.y = y;
  this.color = color;
  this.eated = eated;
}

function Group(id) {
  this.id = id;
  this.dame = 0;
  this.alive = true;
  this.cells = [];
  this.stone = 'n';
}

const game = {
  size: 9,
  grid: [],
  eatWhite: 0,
  eatBlack: 0,
  turnsCount: 0,
  blackTurn: true,
  color: 'B',
  turns: [],
  score: '',
  gameid: 0,
  sgf: '',

  collectGroups() {
    function fillsameGroup(x, y, gid, g) {
      const group = g;
      game.grid[x][y].group = gid;
      group.cells.push({ x, y });
      group.stone = game.grid[x][y].stone;
      group.dame += game.grid[x][y].dame;
      if (x > 0 && game.grid[x - 1][y].group === 0
            && game.grid[x - 1][y].stone === game.grid[x][y].stone) {
        fillsameGroup(x - 1, y, gid, group);
      }
      if (x < game.size - 1 && game.grid[x + 1][y].group === 0
            && game.grid[x + 1][y].stone === game.grid[x][y].stone) {
        fillsameGroup(x + 1, y, gid, group);
      }
      if (y > 0 && game.grid[x][y - 1].group === 0
            && game.grid[x][y - 1].stone === game.grid[x][y].stone) {
        fillsameGroup(x, y - 1, gid, group);
      }
      if (y < game.size - 1 && game.grid[x][y + 1].group === 0
            && game.grid[x][y + 1].stone === game.grid[x][y].stone) {
        fillsameGroup(x, y + 1, gid, group);
      }
    }
    for (let x = 0; x < game.size; x += 1) {
      for (let y = 0; y < game.size; y += 1) {
        game.grid[x][y].group = 0;
      }
    }
    let nextId = 1;
    const groups = [];
    for (let x = 0; x < game.size; x += 1) {
      for (let y = 0; y < game.size; y += 1) {
        if (game.grid[x][y].group === 0 && game.grid[x][y].stone !== 'n') {
          const g = new Group(nextId);
          groups.push(g);
          fillsameGroup(x, y, nextId, g);
          nextId += 1;
        }
      }
    }
    return groups;
  },

  killGroups(stone) {
    const groups = game.collectGroups();
    const eated = [];
    for (let i = 0; i < groups.length; i += 1) {
      if (groups[i].dame === 0 && groups[i].stone !== stone) {
        for (let k = 0; k < groups[i].cells.lenght; k += 1) {
          const x = groups[i].cells[k].x;
          const y = groups[i].cells[k].y;
          eated.push(new Turn(x, y, game.grid[x][y].stone));
          game.grid[x][y].stone = 'n';
          if (stone === 'W') game.eatWhite += 1; else game.eatBlack += 1;
          game.updateDame(x, y);
        }
      }
    }
    return eated;
  },
  calcDame(x, y) {
    return 4 - ((x === game.size - 1 || x === 0) ? 1 : 0) -
      ((y === game.size - 1 || y === 0) ? 1 : 0);
  },
  recalcDame(x, y) {
    return 4 - ((x === game.size - 1 || game.grid[x + 1][y].existStone()) ? 1 : 0)
           - ((x === 0 || game.grid[x - 1][y].existStone()) ? 1 : 0)
           - ((y === game.size - 1 || game.grid[x][y + 1].existStone()) ? 1 : 0)
           - ((y === 0 || game.grid[x][y - 1].existStone()) ? 1 : 0);
  },
  updateDame(x, y) {
    game.grid[x][y].dame = game.recalcDame(x, y);
    if (x > 0 && game.grid[x - 1][y].existStone()) {
      game.grid[x - 1][y].dame = game.recalcDame(x - 1, y);
    }
    if (y > 0 && game.grid[x][y - 1].existStone()) {
      game.grid[x][y - 1].dame = game.recalcDame(x, y - 1);
    }
    if (x < game.size - 1 && game.grid[x + 1][y].existStone()) {
      game.grid[x + 1][y].dame = game.recalcDame(x + 1, y);
    }
    if (y < game.size - 1 && game.grid[x][y + 1].existStone()) {
      game.grid[x][y + 1].dame = game.recalcDame(x, y + 1);
    }
  },

  changeTurn() {
    this.blackTurn = !this.blackTurn;
    this.color = this.blackTurn ? 'B' : 'W';
  },
  turn(x, y) {
    if (x < game.size && y < game.size && x >= 0 && y >= 0) {
      if (game.grid[x][y].stone === 'n') {
        this.turnsCount += 1;
        game.grid[x][y].stone = (game.color);
        game.updateDame(x, y);
        const eated = game.killGroups(game.grid[x][y].stone);
        this.turns.push(new Turn(x, y, game.color, eated));
        this.changeTurn();
      }
    }
  },
  back() {
    this.changeTurn();
    this.turnsCount += 1;
    const t = this.turns.pop();
    if (!t) return;
    game.grid[t.x][t.y].stone = 'n';
    game.updateDame(t.x, t.y);
  },
  makesgf() {
    game.sgf = `(;GM[1]FF[4]\nSZ[${game.size}]\nGN[GNU Go 3.5.4 Random Seed ${game.gameid} level 10]\n`
    + `DT[${now()}]\nKM[0.0]AP[GNU Go:3.5.4]RU[Japanese]HA[0]\n${
    toSgf(game.turns)
    })`;
  },
};

function initCells() {
  game.turns = [];
  for (let x = 0; x < game.size; x += 1) {
    game.grid[x] = [];
  }
  for (let x = 0; x < game.size; x += 1) {
    for (let y = 0; y < game.size; y += 1) {
      game.grid[x][y] = new Cell('n', game.calcDame(x, y));
    }
  }
}
function initGame() {
  game.grid = [];
  game.eatWhite = 0;
  game.eatBlack = 0;
  game.turnsCount = 0;
  game.blackTurn = true;
  game.turns = [];
  initCells();
  game.gameid = Math.ceil(1000000000 * Math.random());
}


const clients = [];

clients.has = function has(x) {
  return (this.filter(a => a.id === x)).length !== 0;
};

clients.gets = function gets(x) {
  return (this.filter(a => a.id === x))[0];
};

clients.add = function add(x, c) {
  this.push({ id: x, color: c });
};

initGame();

function reqTypeIs(req, type) {
  return (req.url.indexOf(type) !== -1);
}

const gg = 'gnugo.exe';
http.createServer((req, res) => {
  let data = '';
  const purl = url.parse(req.url, true);

  if (reqTypeIs(req, 'score')) {
    game.makesgf(game);
    const fn = `qming${now()}_${game.gameid}.sgf`;
    fs.writeFileSync(fn, game.sgf);
    const line = `${gg} --quiet -l ${fn}--score estimate`;
    exec(line, (error, stdout, stderr) => {
      let s = '';
      s = stdout + stderr;
      game.score = s;
      res.writeHead(200, { 'Content-Type': 'text/plain' });
      res.end('{}');
    });
  }

  if (reqTypeIs(req, 'back')) {
    game.back();
    res.writeHead(200, { 'Content-Type': 'text/plain' });
    res.end('{}');
  } else
  if (req.url.indexOf('reset') !== -1) {
    initGame();
    res.writeHead(200, { 'Content-Type': 'text/plain' });
    res.end('{}');
  } else
  if (req.url.indexOf('/data') !== -1) {
    game.turn(parseInt(purl.query.x, 10), parseInt(purl.query.y, 10));
    res.writeHead(200, { 'Content-Type': 'text/plain' });
    res.end('{}');
  } else
  if ((req.url.indexOf('/refresh') !== -1)) {
    res.writeHead(200, { 'Content-Type': 'text/json' });
    res.end(JSON.stringify(game));
  } else
  if (fs.existsSync(`.${req.url}`)) {
    data = fs.readFileSync(`.${req.url}`);
    res.writeHead(200, { 'Content-Type': 'text/html' });
    res.end(data);
  } else res.writeHead(404, { 'Content-Type': 'text/html' });
}).listen(1506);

