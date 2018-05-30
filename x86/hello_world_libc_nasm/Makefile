
all: hello

run: hello
	./hello

clean:
	rm -f hello.o hello

hello: hello.o
	gcc -m32 -nostartfiles hello.o -o hello

hello.o: hello.s
	nasm -f elf hello.s

