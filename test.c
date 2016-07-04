#include <stdio.h>
#include <string.h>
#include "floatfann.h"

int nn_2_val(fann_type* out) {
	fann_type max = 0;
	int maxidx = 0;
	int i = 0;
	for (i = 0; i < 10; ++i) {
		if (out[i] > max) {
			maxidx = i;
			max = out[i];
		}
	}
	return maxidx;
}

int main(void) {
	fann_type *calc_out;
	fann_type input[784];

	struct fann *ann = fann_create_from_file("numbers.net");
	FILE* fh;
	fh = fopen("./test.fann", "r");
	if (fh == NULL){
		printf("file doesn't exist!\n");
		return 0;
	}
	//read line by line
	const size_t line_size = 8192;
	char* line = malloc(line_size);
	int i = 0;
	int val;
	int gt;
	int got = 0;
	while (fgets(line, line_size, fh) != NULL)  {
		++i;
		if (i == 1) {
			continue;
		}
		char* pch;
		int j = 0;
		pch = strtok(line, " ");
		while (pch != NULL) {
			input[j++] = atof(pch);
			pch = strtok(NULL, " ");
		}
		if (i % 2 == 0) {
			calc_out = fann_run(ann, input);
			val = nn_2_val(calc_out);
		} else {
			gt = nn_2_val(input);
			if (val == gt) {
				++got;
			}
		}
	}
	printf("got %d/10000", got);
	free(line);
	fann_destroy(ann);
	return 0;
}
