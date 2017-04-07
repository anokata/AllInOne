run:
	mkdir out || echo 'dir exist, ok'
	rm out/*.js || echo 'no files, ok'
	#for babel src/*.js > out/
	webpack out/*.js out/bundle.js
	firefox 'localhost:1506/html/screen.test.html'&
	#nodejs server.js
