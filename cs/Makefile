compile:
	mcs test.cs

run:
	mono test.exe

wincompile:
	mcs winhi.cs -r:System.Windows.Forms.dll

win2:
	mcs $@.cs -r:System.Windows.Forms.dll -r:System.Drawing.dll
	mono $@.exe

clean:
	rm *.exe

chatserver:
	mcs $@.cs -r:System.Windows.Forms.dll -r:System.Drawing.dll
	mono $@.exe

chatclient:
	mcs $@.cs -r:System.Windows.Forms.dll -r:System.Drawing.dll
	mono $@.exe
