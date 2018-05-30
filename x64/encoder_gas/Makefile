
all: encoder

run: encoder
	./encoder

clean:
	rm -f encoder.o encoder

encoder: encoder.o
	gcc -lc -nostartfiles encoder.o -o encoder

encoder.o: encoder.s
	as -64 encoder.s -c -o encoder.o

decoder_stub.o: decoder_stub.s
	as -64 decoder_stub.s -c -o decoder_stub.o
