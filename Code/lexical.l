%{
#include <stdio.h>
#include "syntax.tab.h"
#include "tree.h"
%}

letter [_a-zA-Z]
space [ \n\t\r]
float (([1-9][0-9]*)|0)\.[0-9]+
%option yylineno
id {letter}({letter}|[0-9])*

%%
{space}+					{  }	
{float}						{ yylval = newNode("float");  return FLOAT;}
[1-9][0-9]*					{ yylval = newNode("Int"); return INT; }
";"							{ yylval = newNode("SEMI"); return SEMI;}
","							{ yylval = newNode("COMMA"); return COMMA;}
"="							{ yylval = newNode("ASSIGNOP"); return ASSIGNOP;}
">"|"<"|">="|"<="|"=="|"!="	{ yylval = newNode("RELOP"); return RELOP;}
"\+"						{ yylval = newNode("PLUS"); return PLUS;}
"-"							{ yylval = newNode("MINUS"); return MINUS;}
"\*"						{ yylval = newNode("STAR"); return STAR;}
"/"							{ yylval = newNode("DIV"); return DIV;}
"&&"						{ yylval = newNode("AND"); return AND;}
"\|\|"						{ yylval = newNode("OR"); return OR;}
"."							{ yylval = newNode("DOT"); return DOT;}
"!"							{ yylval = newNode("NOT"); return NOT;}
"int"|"float"				{ yylval = newNode("TYPE"); return TYPE;}
"("							{ yylval = newNode("LP"); return LP;}
")"							{ yylval = newNode("RP"); return RP;}
"\["						{ yylval = newNode("LB"); return LB;}
"\]"						{ yylval = newNode("RB"); return RB;}
"\{"						{ yylval = newNode("LC"); return LC;}
"\}"						{ yylval = newNode("RC"); return RC;}
"struct"					{ yylval = newNode("STRUCT"); return STRUCT;}
"return"					{ yylval = newNode("RETURN"); return RETURN;}
"if"						{ yylval = newNode("IF"); return IF;}
"else"						{ yylval = newNode("ELSE"); return ELSE;}
"while"						{ yylval = newNode("WHILE"); return WHILE;}
{id}						{ yylval = newNode("ID"); return ID;}
. { fprintf(stderr, "Error type A at Line %d: Interesting characters \'%s\'\n", yylineno, yytext); 
	char c = input();
	while (c !='\n') c = input();
}

%%
/*
int main(int argc, char** argv) {
	if (argc > 1) {
		if (!(yyin = fopen(argv[1], "r"))) {
			perror(argv[1]);
			return 1;
		}
	}
	while (yylex() != 0)
		return 0;
}
*/
