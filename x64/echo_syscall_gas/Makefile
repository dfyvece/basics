
all: echo

run: echo
	./echo

clean:
	rm -f echo.o echo

echo: echo.o
	gcc -lc -nostartfiles echo.o -o echo

echo.o: echo.s
	as -64 echo.s -c -o echo.o

