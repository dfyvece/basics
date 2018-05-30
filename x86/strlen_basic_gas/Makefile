
all: strlen

run: strlen
	./strlen

clean:
	rm -f strlen.o strlen

strlen: strlen.o
	gcc -m32 -nostartfiles strlen.o -o strlen

strlen.o: strlen.s
	as -32 strlen.s -c -o strlen.o

