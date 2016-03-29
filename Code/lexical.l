digit [0-9]
letter [_a-zA-Z]
space [ \n\t\r]
%option yylineno
%%
{space}+					{  }	
-?(([1-9]{digit}*)|0)\.{digit}+			{ printf("Float val %f\n", atof(yytext)); }
-?[1-9]{digit}*				{ printf("Int val %d\n", atoi(yytext)); }
";"							{ printf("SEMI\n"); }
","							{ printf("COMMA\n"); }
"="							{ printf("ASSIGNOP\n"); }
">"|"<"|">="|"<="|"=="|"!="	{ printf("RELOP\n");}
"\+"						{ printf("PLUS\n"); }
"-"							{ printf("MINUS\n"); }
"\*"						{ printf("STAR\n"); }
"/"							{ printf("DIV\n"); }
"&&"						{ printf("AND\n"); }
"\|\|"						{ printf("OR\n"); }
"."							{ printf("DOT\n"); }
"!"							{ printf("NOT\n"); }
"int"|"float"				{ printf("TYPE\n"); }
"("							{ printf("LP\n"); }
")"							{ printf("RP\n"); }
"\["						{ printf("LB\n"); }
"\]"						{ printf("RB\n"); }
"\{"						{ printf("LC\n"); }
"\}"						{ printf("RC\n"); }
"struct"					{ printf("STRUCT\n"); }
"return"					{ printf("RETURN\n"); }
"if"						{ printf("IF\n"); }
"else"						{ printf("ELSE\n"); }
"while"						{ printf("WHILE\n"); }
{letter}+[{letter}|{digit}]* {printf("ID\n"); }
. { printf("Error type A at Line %d: Interesting characters \'%s\'\n", yylineno, yytext); 
	char c = input();
	while (c !='\n') c = input();
}
%%

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
