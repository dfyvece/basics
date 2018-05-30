
all: xor

run: xor
	./xor

clean:
	rm -f xor.o xor

xor: xor.o
	gcc -lc -nostartfiles xor.o -o xor

xor.o: xor.s
	as -64 xor.s -c -o xor.o

