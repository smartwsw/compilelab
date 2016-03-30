#include "tree.h"
#include <stdio.h>
#include "syntax.tab.h"

void yyrestart(FILE *f);

int main(int argc, char** argv) {
	if (argc <= 1)
		return 1;
	FILE* f = fopen(argv[1], "r");
	if (!f) {
		perror (argv[1]);
		return 1;
	}
	errornum = 0;
	yyrestart(f);
	yyparse();
	if (errornum == 0 && root != NULL) {
		print(root, 0);
	}
	else {
		printf("\e[31mTotal errors: %d\e[0m\n", errornum);
	}
	return 0;
}

