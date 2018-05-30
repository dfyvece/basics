
all: hello

run: hello
	./hello

clean:
	rm -f hello.o hello

hello: hello.o
	ld hello.o -o hello

hello.o: hello.s
	as -64 hello.s -c -o hello.o

