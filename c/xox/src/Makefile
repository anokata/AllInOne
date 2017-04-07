SRC = main.c xoxo.c xoxogdk.c pointList.c
OBJ = main.o xoxo.o xoxogdk.o pointList.o
PROG = gamexoxo
GTKOPTIONS = `pkg-config --cflags gtk+-2.0` `pkg-config --libs gtk+-2.0`

all: $(PROG)

$(OBJ): $(SRC)
	gcc $(SRC) -c $(GTKOPTIONS)

$(PROG): $(OBJ)
	gcc $(OBJ) -o $(PROG) $(GTKOPTIONS)

RMQ = 2>/dev/null
clean:
	rm *.o $(RMQ); rm *.out $(RMQ); rm $(PROG) $(RMQ)

gitpush:
	git commit -a && git push rem_xoxo master

gitadd:
	git add .



