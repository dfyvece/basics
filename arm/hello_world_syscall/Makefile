
all: hello

run: hello
	qemu-arm ./hello

debug: hello
	qemu-arm -g 10101 ./hello

clean:
	rm -f hello.o hello

hello: hello.o
	arm-linux-gnueabi-ld hello.o -o hello

hello.o: hello.s
	arm-linux-gnueabi-as hello.s -o hello.o

