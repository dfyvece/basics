
all: shell

run: shell
	./shell

clean:
	rm -f shell.o shell

shell: shell.o
	gcc -lc -nostartfiles shell.o -o shell

shell.o: shell.s
	as -64 shell.s -c -o shell.o

