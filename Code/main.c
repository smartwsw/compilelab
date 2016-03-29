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
	yyrestart(f);
	yyparse();
	print(root, 0);
	return 0;
}

