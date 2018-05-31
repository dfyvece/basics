
all: cosines

run: cosines
	./cosines

clean:
	rm -f cosines.o cosines

cosines: cosines.o
	gcc -lc -nostartfiles cosines.o -o cosines

cosines.o: cosines.s
	as -64 cosines.s -c -o cosines.o

