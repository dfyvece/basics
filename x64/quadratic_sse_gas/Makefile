
all: pythagorean

run: pythagorean
	./pythagorean

clean:
	rm -f pythagorean.o pythagorean

pythagorean: pythagorean.o
	gcc -lc -nostartfiles pythagorean.o -o pythagorean

pythagorean.o: pythagorean.s
	as -64 pythagorean.s -c -o pythagorean.o

