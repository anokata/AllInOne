run:
	mkdir out || echo 'dir exist, ok'
	rm out/*.js || echo 'no files, ok'
	babel game.js > out/game.js
	babel ui.js > out/ui.js
	webpack out/*.js out/bundle.js
	firefox 'localhost:1506/game.html'&
	nodejs server.js
