
all: hello

run: hello
	./hello

clean:
	rm -f hello.o hello

hello: hello.o
	gcc -no-pie -nostartfiles hello.o -o hello

hello.o: hello.s
	nasm -f elf64 hello.s

