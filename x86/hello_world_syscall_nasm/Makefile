
all: hello

run: hello
	./hello

clean:
	rm -f hello.o hello

hello: hello.o
	ld -melf_i386 hello.o -o hello

hello.o: hello.s
	nasm -f elf hello.s

