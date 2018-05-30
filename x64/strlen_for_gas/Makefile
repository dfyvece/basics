
all: strlen

run: strlen
	./strlen

clean:
	rm -f strlen.o strlen

strlen: strlen.o
	gcc -lc -nostartfiles strlen.o -o strlen

strlen.o: strlen.s
	as -64 strlen.s -c -o strlen.o

