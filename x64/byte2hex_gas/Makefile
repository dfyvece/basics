
all: byte2hex

run: byte2hex
	./byte2hex

clean:
	rm -f byte2hex.o byte2hex

byte2hex: byte2hex.o
	gcc -lc -nostartfiles byte2hex.o -o byte2hex

byte2hex.o: byte2hex.s
	as -64 byte2hex.s -c -o byte2hex.o

