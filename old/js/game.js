import { newElem, createDiv, createButton, createLabel, createSwitch } from './ui';
// TODO:   chat. games. undo(turn history). ko rule, not access self dest move, territory count.
// new game create with size
// step count & it as ID on server. / every second ajax server and JSON.parse new turns
// надо чтоб ходы были строго по очереди.
// а для этого сервер должен знать кто есть кто? и игроки должны выбирать?
// надо что было покл к игре.
// список игр. сервер игр. переместить всё состояние на серв. и список их.
// подкл как игр. набл.
// или чтоб на сервер слал и цвет. а лучше там всё хранить
// при первом подкл - брать все. и кнопку
// перенести логику игры на сервер. комнаты.
// Улучшить undo чтоб он использовал съеденные из turns.eated
const body = document.body;
// ============== game ==============
let game;
let ctx;

const serverUrl = 'http://localhost:1506';
function ajaxSend(data) { // TODO remove
  const req = new XMLHttpRequest();
  req.open('GET', serverUrl + data, false);
  req.setRequestHeader('clientID', game.clientID);
  req.send(null);
  return JSON.parse(req.responseText);
}

function sendAjax(data, handler) {
  const request = new XMLHttpRequest();
  request.open('GET', serverUrl + data, true);
  request.onload = function fun() {
    const response = JSON.parse(this.responseText);
    return handler(response);
  };
  request.send(null);
  return request.status;
}

function updateCountLabel() {
  game.lb1.textContent = '';
  game.lb1.textContent += 'black: ';
  game.lb1.textContent += game.eatBlack;
  game.lb1.textContent += 's | white: ';
  game.lb1.textContent += game.eatWhite;
  game.lb1.textContent += 's turn# ';
  game.lb1.textContent += game.turnsCount;
}

function drawStonewElem(x, y, c, t, last) {
  ctx.fillStyle = c;
  ctx.lineWidth = 2;
  ctx.beginPath();
  ctx.arc(x, y, game.step / 2.5, 0, Math.PI * 2, true);
  ctx.stroke();
  ctx.fill();
  ctx.fillStyle = '#c00';
  if (last) {
    ctx.fillRect(x - (game.step / 6), y - (game.step / 6),
          game.step / 3, game.step / 3);
  }
  if (game.debug.drawDame) {
    ctx.fillStyle = '#f00';
    ctx.font = '11px Arial';
    ctx.fillText(t, x - (game.step / 5), y + (game.step / 7));
  }
}
function drawGStonewElem(x, y, c) {
  drawStonewElem((x * game.step) + game.border, (y * game.step) + game.border,
          c, game.grid[x][y].dame,
          (game.last.x === x && game.last.y === y));
}
function drawBGStonewElem(x, y) { drawGStonewElem(x, y, '#000'); }
function drawWGStonewElem(x, y) { drawGStonewElem(x, y, '#fff'); }

function drawgrid(g) {
  ctx.fillStyle = '#fff';
  ctx.clearRect(0, 0, game.w + game.border, game.h + game.border);

  ctx.lineWidth = 2;
  ctx.fillStyle = '#000';
  ctx.beginPath();
  for (let x = game.border; x <= game.w; x += game.step) {
    ctx.beginPath();
    ctx.moveTo(x, game.border);
    ctx.lineTo(x, (game.h - game.step) + game.border);
    ctx.stroke();
    ctx.beginPath();
    ctx.moveTo(game.border, x);
    ctx.lineTo((game.w - game.step) + game.border, x);
    ctx.stroke();
  }
  for (let x = 0; x < g.length; x += 1) {
    for (let y = 0; y < g[x].length; y += 1) {
      if (g[x][y].stone === 'B') {
        drawBGStonewElem(x, y);
      } else if (g[x][y].stone === 'W') {
        drawWGStonewElem(x, y);
      }
    }
  }
}

function newDataFromServer() {
  const newdata = ajaxSend('/refresh');
  if (game.turnsCount < newdata.turnsCount) {
    document.title = `#${newdata.turnsCount}NEW`;
  } else {
    document.title = `#${newdata.turnsCount}no new`;
  }
  game.turnsCount = newdata.turnsCount;
  game.grid = newdata.grid;
  game.score = newdata.score;
  game.turns = newdata.turns;
  game.eatWhite = newdata.eatWhite;
  game.eatBlack = newdata.eatBlack;
  game.blackTurn = newdata.blackTurn;
  game.last.x = game.turns.length === 0 ? 0 : game.turns[game.turns.length - 1].x;
  game.last.y = game.turns.length === 0 ? 0 : game.turns[game.turns.length - 1].y;
  game.labelScore.textContent = game.score;
}

function newDataToServer(x, y) {
  const newdata = ajaxSend(`/data?x=${x}&y=${y}`);
  game.turnsCount = newdata.turnsCount;
  game.grid = newdata.grid;
}

function refresh() {
  newDataFromServer();
  game.drawTurn();
  updateCountLabel();
  drawgrid(game.grid);
}

game = {
  debug: { changeColor: true, drawDame: true, drawField: true },
  size: 9,
  border: 20,
  w: 300,
  h: 300,
  step: 1,
  grid: [],
  eatWhite: 0,
  eatBlack: 0,
  turnsCount: 0,
  last: { x: 0, y: 0 },
  blackTurn: true,
  turns: [],
  clientID: 0,
  score: '',
  labelTurn: {},
  labelScore: {},
  infoPanel: {},
  lb1: {},

  drawTurn() {
    this.labelTurn.textContent = `now turn ${this.blackTurn ? 'black' : 'white'}`;
  },

  turn(x, y, fromServer) {
        // console.log(x+" "+y);
    if (x < game.size && y < game.size && x >= 0 && y >= 0) {
      if (!fromServer) {
        newDataToServer(x, y);
      }
      refresh();
      game.last.x = game.turns[game.turns.length - 1].x;
      game.last.y = game.turns[game.turns.length - 1].y;
      this.drawTurn();
      updateCountLabel();
      drawgrid(game.grid);
    }
  },

  back() {
    ajaxSend('/back');
    this.drawTurn();
    newDataFromServer();
    updateCountLabel();
    drawgrid(game.grid);
  },
};
// ==================================
const can = newElem('canvas');
const wb = game.w + game.border + 20;
function createSwitches() {
  const sw1 = createSwitch(game.infoPanel);
  sw1.action = function action() { game.debug.changeColor = this.on; };
  sw1.label.textContent = 'same stone';
  const sw2 = createSwitch(game.infoPanel);
  sw2.action = function act() { game.debug.drawDame = this.on; drawgrid(game.grid); };
  sw2.label.textContent = 'draw dame';
  sw2.toggle();
  game.lb1 = createLabel(game.infoPanel, 'black: 0s | white: 0s');
  const sw3 = createSwitch(game.infoPanel);
  sw3.action = function s3act() {
    game.debug.drawField = this.on;
    can.style.visibility = game.debug.drawField ? 'visible' : 'hidden';
  };
}
function createInfoPanel(parent) {
  game.infoPanel = newElem('div');
  parent.appendChild(game.infoPanel);
  game.infoPanel.appendChild(game.labelTurn);
  game.infoPanel.style.backgroundColor = '#ace';
  game.infoPanel.style.width = '200px';
  game.infoPanel.style.height = `${wb}px`;
  game.infoPanel.style.position = 'absolute';
  game.infoPanel.style.display = 'inline-block';
  game.infoPanel.style.cssFloat = 'left';
}
function createLabelTurn() {
  game.labelTurn = newElem('div');
  game.labelTurn.textContent = 'now turn black';
  game.labelTurn.style.backgroundColor = '#ace';
  game.labelTurn.onmousedown = function omd(e) { e.preventDefault(); };
  game.labelTurn.style.cursor = 'default';
  game.labelTurn.onmousemove = function omm(e) { e.preventDefault(); };
}
function initGame() {
  game.step = game.w / game.size;
  game.labelScore = createLabel(game.infoPanel, '------');
  game.labelScore.style.width = '300px';
  newDataFromServer();
  drawgrid(game.grid);
  game.clientID = Math.ceil(10000 * Math.random());
}

function getScore() {
  ajaxSend('/score');
  newDataFromServer();
}

function createButtons() {
  createButton(game.infoPanel, () => {
    ajaxSend('/reset');
    initGame();
  }, 'Reset server');

  createButton(game.infoPanel, () => {
    game.back();
  }, 'Undo');

  const timer = setInterval(refresh, 1000);
  createButton(game.infoPanel, () => {
    clearInterval(timer);
  }, 'Stop');

  const btnRefresh = createButton(game.infoPanel, refresh, 'Refresh');
  btnRefresh.style.marginTop = '45px';

  const btnScore = createButton(game.infoPanel, getScore, 'Score territory');
  btnScore.style.width = '200px';
  btnScore.style.backgroundColor = '#fe8';
}

function initUI(parent) {
  const field = newElem('div');
  parent.appendChild(field);
  field.appendChild(can);
  field.style.backgroundColor = '#dda';
  field.style.width = `${wb}px`;
  field.style.height = `${wb}px`;
  field.style.left = '10px';
  field.style.position = 'relative';
  field.style.display = 'inline-block';
  field.style.cssFloat = 'left';
  can.style.visibility = 'visible';
  createLabelTurn();
  createInfoPanel(parent);
  createSwitches();
  createButtons();
}

function main() {
  body.onmousemove = function onmousemove(e) { e.preventDefault(); };
  can.width = game.w + game.border;
  can.height = game.h + game.border;
  ctx = can.getContext('2d');
  can.onmousedown = function onmousemove(e) {
    game.turn(Math.floor((e.x - game.border) / game.step),
              Math.floor((e.y - game.border) / game.step));
  };
  const all = createDiv();
  initUI(all);
  initGame();
}

main();

