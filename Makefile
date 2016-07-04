LDFLAGS += $(shell pkg-config --libs fann)
CFLAGS += $(shell pkg-config --cflags fann)

test:
	$(CC) $(CFLAGS) test.c -o test $(LDFLAGS)

train:
	$(CC) $(CFLAGS) train.c -o train $(LDFLAGS)

unzip:
	zcat test.fann.gz > test.fann
	zcat train.fann.gz > train.fann

clean:
	rm -f test train

.PHONY: test train clean
