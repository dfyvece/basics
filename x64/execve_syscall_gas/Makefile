
all: execve

run: execve
	./execve

clean:
	rm -f execve.o execve

execve: execve.o
	gcc -lc -nostartfiles execve.o -o execve

execve.o: execve.s
	as -64 execve.s -c -o execve.o

