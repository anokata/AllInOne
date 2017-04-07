
export const newElem = function newElem(x) {
  return document.createElement(x);
};
const addToBody = function addToBody(x) {
  return document.body.appendChild(x);
};
export function createDiv() {
  const z = newElem('div'); addToBody(z); return z;
};

export function createButton(where, onclk, text) {
  const but = newElem('div');
  but.textContent = text || '';
  const style = but.style;
  style.backgroundColor = '#ad0';
  style.width = '50px';
  style.height = '20px';
  style.position = 'relative';
  style.left = '0px';
  style.top = '0px';
  style.whiteSpace = 'nowrap';
  style.marginTop = '5px';
  but.cursor = 'default';
  where.appendChild(but);
  but.onmousedown = function onmousedown(e) { but.style.backgroundColor = '#fd0'; e.preventDefault(); };
  but.onmouseup = function onmouseup() { but.style.backgroundColor = '#ad0'; };
  but.ondblclick = function ondblclick() {};
  but.onclick = onclk;
  return but;
}

export function createLabel(to, text) {
  const label = newElem('div');
  to.appendChild(label);
  label.textContent = text;
  const style = label.style;
  style.position = 'relative';
  style.float = 'left';
  style.width = '200px';
  style.top = '-0px';
  style.cursor = 'default';
  style.fontFamily = 'monospace';
  label.onmousedown = prevent;
  label.ondblclick = prevent;
  return label;
}

const prevent = function prevent(e) { e.preventDefault(); };

export function createSwitch(to) {
  const container = newElem('div');
  container.style.width = '40px';
  container.style.height = '14px';
  to.appendChild(container);
  container.style.backgroundColor = '#fff';
  const style = container.style;
  style.borderColor = '#000';
  style.borderWidth = '2px';
  style.borderStyle = 'solid';
  style.marginBottom = '5px';
  style.whiteSpace = 'nowrap';
  const label = newElem('div');

  container.label = label;
  label.style.position = 'relative';
  label.style.float = 'left';
  label.style.width = '100px';
  label.style.left = '50px';
  label.style.top = '-20px';
  label.style.cursor = 'default';
  label.onmousedown = prevent;
  label.ondblclick = prevent;

  const bar = newElem('div');
  bar.style.width = '15px';
  bar.style.height = '10px';
  container.appendChild(bar);
  container.appendChild(label);
  bar.style.backgroundColor = '#0c0';
  bar.style.left = '0px';
  bar.style.position = 'relative';
  bar.style.borderColor = '#0d0';
  bar.style.borderWidth = '2px';
  bar.style.borderStyle = 'solid';
  container.on = false;
  container.toggle = function toggle() {
    bar.style.left = `${this.on ? 0 : 21}px`;
    this.action();
    this.on = !this.on;
  };
  container.onmousedown = function onmousedown() { this.toggle(); };
  container.action = function action() {};

  return container;
}
