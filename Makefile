LDFLAGS += $(shell pkg-config --libs fann)
CFLAGS += $(shell pkg-config --cflags fann)

test:
	$(CC) $(CFLAGS) test.c -o test $(LDFLAGS)

train:
	$(CC) $(CFLAGS) train.c -o train $(LDFLAGS)

unzip:
	gunzip test.fann.gz
	gunzip train.fann.gz

clean:
	rm -f test train
