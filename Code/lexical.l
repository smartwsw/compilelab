%{
#include <stdio.h>
#include "syntax.tab.h"
#include "tree.h"
%}

letter		[_a-zA-Z]
space		[ \n\t\r]
float		(([1-9][0-9]*)|0)\.[0-9]+
id			{letter}({letter}|[0-9])*
oct			0[0-7]+
hex			0[xX][0-9a-fA-f]+
eoct		0[0-9]+
ehex		0[xX][0-9a-fA-F]*[g-zG-Z][0-9A-Za-z]*
%option yylineno
%%
{space}+					{	printf("This is a space!\n");}	
{float}						{ 
								char buffer[64] = "FLOAT: ";
								strcat(buffer, yytext);
								yylval = newNode(buffer);  
								return FLOAT;
							}
[1-9][0-9]*|0				{ 
								char buffer[64] = "INT: ";
								strcat(buffer, yytext);
								yylval = newNode(buffer); 
								return INT; 
							}
{hex}						{
								int val;
								char buffer[64];
								if (yytext[1] == 'X') {
									sscanf(yytext, "0X%x", &val);
								}
								else {
									sscanf(yytext, "0x%x", &val);
								}
								sprintf(buffer, "INT: %d", val);
								return INT;
							}
{oct}						{
								int val;
								char buffer[64];
								sscanf(yytext, "0%o", &val);
								sprintf(buffer, "INT: %d", val);
								return INT;
							}
{eoct}						{	
								fprintf(stderr, "Error type A at line %d: Illegal oct num \"%s\"\n", yylineno, yytext);
								errornum++;
								yylval = newNode("INT: ERROR");
								return INT;
							}
{ehex}						{
								fprintf(stderr, "Error type A at line %d: Illegal hex num \"%s\"\n", yylineno, yytext);
								errornum++;
								yylval = newNode("INT: ERROR");
								return INT;
							}
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
"int"						{ yylval = newNode("TYPE: int"); return TYPE;}
"float"						{ yylval = newNode("TYPE: float"); return TYPE;}
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
{id}						{ 
								char buffer[64] = "ID: ";
								strcat(buffer, yytext);
								yylval = newNode(buffer); return ID;}
.							{ 
								fprintf(stderr, "Error type A at Line %d: Interesting characters \'%s\'\n", yylineno, yytext); 
								errornum++;
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
