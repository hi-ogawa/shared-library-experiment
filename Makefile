all: plus.c main.c
	gcc plus.c -c -fpic -I./
	gcc plus.o -o libplus.so -shared
	gcc main.c -o main -I./ -L./ -lplus

clean:
	rm -rf plus.o libplus.so main
