#ifndef __TREE_H__
#define __TREE_H__
struct Node {
	struct Node *child[10];
	int line;
	char type[64];
	int val;
};

struct Node *newNode(char *type);
void addChild(struct Node *parent, struct Node *child);
void print(struct Node *root, int level);

struct Node *root;

#endif

