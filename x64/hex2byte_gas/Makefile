
all: hex2byte

run: hex2byte
	./hex2byte

clean:
	rm -f hex2byte.o hex2byte

hex2byte: hex2byte.o
	gcc -lc -nostartfiles hex2byte.o -o hex2byte

hex2byte.o: hex2byte.s
	as -64 hex2byte.s -c -o hex2byte.o

