#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include "tree.h"
//#include "syntax.tab.h"

extern int yylineno;

struct Node *newNode(char *type) {
	struct Node *new = (struct Node *)malloc(sizeof(struct Node));
	int i = 0;
	for(i = 0; i < 10; i++) {
		new->child[i] = NULL;
	}
	new->line = yylineno;
	strcpy(new->type, type);
	new->val = 0;
//	printf("%d, %s\n", new->line, type);
	return new;
}

void addChild(struct Node *parent, struct Node *child) {
	if (child == NULL)
		return;
	parent->child[parent->val] = child;
	parent->val++;
	parent->line = parent->child[0]->line;
}

void print(struct Node *root, int level) {
	if (root == NULL)
		return;
	int i = 0;
	for (i = 0; i < level; i++) {
		printf("  ");
	}
	if (root->val == 0) {
		printf("%s\n", root->type);
	}
	else {
		printf("%s (%d)\n", root->type, root->line);
		int j = 0;
		for (j = 0; j < root->val; j++) {
			print(root->child[j], level + 1);
		}
	}
	return;
}

