%{
#define YYSTYPE struct Node*
#include "lex.yy.c"
#include <stdio.h>
	int yyerror(char* msg);
%}

%token INT
%token FLOAT
%token ID
%token TYPE
%token SEMI
%token COMMA
%token ASSIGNOP
%token RELOP
%token PLUS
%token MINUS
%token STAR
%token DIV 
%token AND 
%token OR
%token DOT 
%token NOT 
%token LP
%token RP
%token LB
%token RB
%token LC
%token RC
%token STRUCT
%token RETURN
%token IF
%token ELSE
%token WHILE

%right ASSIGNOP
%left RELOP
%left OR
%left AND
%left PLUS MINUS
%left STAR DIV
%right NOT
%left DOT LB RB LP RP

%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE
%%

// High-level Defunitions

Program		: ExtDefList
				{	
					$$ = newNode("Program");
					addChild($$, $1);
					root = $$;
				}
			;
ExtDefList	: ExtDef ExtDefList
				{
					$$ = newNode("ExtDefList");
					addChild($$, $1);
					addChild($$, $2);
				}
			|	{	$$ = NULL; }
			;
ExtDef		:	Specifier ExtDecList SEMI
				{
					$$ = newNode("ExtDef");
					addChild($$, $1);
					addChild($$, $2);
					addChild($$, $3);
				}
			|	Specifier SEMI
				{
					$$ = newNode("ExtDef");
					addChild($$, $1);
					addChild($$, $2);
				}
			|	Specifier FunDec CompSt
				{
					$$ = newNode("ExtDef");
					addChild($$, $1);
					addChild($$, $2);
					addChild($$, $3);
				}
			|	Specifier error
				{
					fprintf(stderr, "Missing \";\".\n");
				}
			;
ExtDecList	:	VarDec
				{
					$$ = newNode("ExtDecList");
					addChild($$, $1);
				}
			|	VarDec COMMA ExtDecList
				{
					$$ = newNode("ExtDecList");
					addChild($$, $1);
					addChild($$, $2);
					addChild($$, $3);
				}
			;

// Specifiers

Specifier	:	TYPE
				{
					$$ = newNode("Specifier");
					addChild($$, $1);
				}
			|	StructSpecifier
				{
					$$ = newNode("Specifier");
					addChild($$, $1);
				}
			;
StructSpecifier	:	STRUCT OptTag LC DefList RC
					{
						$$ = newNode("StructSpecifier");
						addChild($$, $1);
						addChild($$, $2);
						addChild($$, $3);
						addChild($$, $4);
						addChild($$, $5);
					}
				|	STRUCT Tag
					{
						$$ = newNode("StructSpecifier");
						addChild($$, $1);
						addChild($$, $2);
					}
				;
OptTag		:	ID
				{
					$$ = newNode("OptTag");
					addChild($$, $1);
				}
			|	{	$$ = NULL; }
			;
Tag			:	ID
				{	
					$$ = newNode("Tag");
					addChild($$, $1);
				}
			;

//Declarators

VarDec		:	ID
				{
					$$ = newNode("VarDec");
					addChild($$, $1);
				}
			|	VarDec LB INT RB
				{
					$$ = newNode("VarDec");
					addChild($$, $1);
					addChild($$, $2);
					addChild($$, $3);
					addChild($$, $4);
				}
			;
FunDec		:	ID LP VarList RP
				{
					$$ = newNode("FunDec");
					addChild($$, $1);
					addChild($$, $2);
					addChild($$, $3);
					addChild($$, $4);
				}
			|	ID LP RP
				{
					$$ = newNode("FunDec");
					addChild($$, $1);
					addChild($$, $2);
					addChild($$, $3);
				}
			;
VarList		:	ParamDec COMMA VarList
				{
					$$ = newNode("VarList");
					addChild($$, $1);
					addChild($$, $2);
					addChild($$, $3);
				}
			|	ParamDec
				{
					$$ = newNode("VarList");
					addChild($$, $1);
				}
			;
ParamDec	:	Specifier VarDec
				{
					$$ = newNode("ParamDec");
					addChild($$, $1);
					addChild($$, $2);
				}
			;

//Statements

CompSt		:	LC DefList StmtList RC
				{
					$$ = newNode("CompSt");
					addChild($$, $1);
					addChild($$, $2);
					addChild($$, $3);
					addChild($$, $4);
				}
			|	error RC
				{
					fprintf(stderr, "Invalid Statements.\n");
				}
			;
StmtList	:	Stmt StmtList
				{
					$$ = newNode("StmtList");
					addChild($$, $1);
					addChild($$, $2);
				}
			|	{$$ = NULL; }
			;
Stmt		:	Exp SEMI
				{
					$$ = newNode("Stmt");
					addChild($$, $1);
					addChild($$, $2);
				}
			|	CompSt
				{
					$$ = newNode("Stmt");
					addChild($$, $1);
				}
			|	RETURN Exp SEMI
				{	
					$$ = newNode("Stmt");
					addChild($$, $1);
					addChild($$, $2);
					addChild($$, $3);
				}
			|	IF LP Exp RP Stmt
				{	
					$$ = newNode("Stmt");
					addChild($$, $1);
					addChild($$, $2);
					addChild($$, $3);
					addChild($$, $4);
					addChild($$, $5);
				}
			|	IF LP Exp RP Stmt ELSE Stmt
				{
					$$ = newNode("Stmt");
					addChild($$, $1);
					addChild($$, $2);
					addChild($$, $3);
					addChild($$, $4);
					addChild($$, $5);
					addChild($$, $6);
					addChild($$, $7);
				}
			|	WHILE LP Exp RP Stmt
				{	
					$$ = newNode("Stmt");
					addChild($$, $1);
					addChild($$, $2);
					addChild($$, $3);
					addChild($$, $4);
					addChild($$, $5);
				}
			|	Exp LB error SEMI
				{
					fprintf(stderr, "Missing \"]\".\n");
				}
			|	IF LP Exp RP error ELSE Stmt
				{
					fprintf(stderr, "Missing \";\".\n");
				}
			|	LP Exp error SEMI
				{
					fprintf(stderr, "Missing \")\".\n");
				}
			|	WHILE LP Exp RP error LC DefList StmtList RC
				{
					fprintf(stderr, "Invalid experission.\n");
				}
			|	error SEMI
				{
					fprintf(stderr, "Invalid statement.\n");
				}
			;

//LocalDefinitions

DefList		:	Def DefList
				{
					$$ = newNode("DefList");
					addChild($$, $1);
					addChild($$, $2);
				}
			|	{	$$ = NULL; }
			;
Def			:	Specifier DecList SEMI
				{
					$$ = newNode("Def");
					addChild($$, $1);
					addChild($$, $2);
					addChild($$, $3);
				}
			|	Specifier error SEMI
				{
					fprintf(stderr, "Missing \",\".\n");
				}
			;
DecList		:	Dec
				{
					$$ = newNode("DecList");
					addChild($$, $1);
				}
			|	Dec COMMA DecList
				{
					$$ = newNode("DecList");
					addChild($$, $1);
					addChild($$, $2);
					addChild($$, $3);
				}
			;
Dec			:	VarDec
				{	
					$$ = newNode("Dec");
					addChild($$, $1);
				}
			|	VarDec ASSIGNOP Exp
				{
					$$ = newNode("Dec");
					addChild($$, $1);
					addChild($$, $2);
					addChild($$, $3);
				}
			;

//Expressions

Exp         : Exp ASSIGNOP Exp
                {
                    $$=newNode("Exp");
                    addChild($$, $1);
                    addChild($$, $2);
                    addChild($$, $3);
                }
            | Exp AND Exp
                {
                    $$=newNode("Exp");
                    addChild($$, $1);
                    addChild($$, $2);
                    addChild($$, $3);
                }
            | Exp OR Exp
                {
                    $$=newNode("Exp");
                    addChild($$, $1);
                    addChild($$, $2);
                    addChild($$, $3);
                }
            | Exp RELOP Exp
                {
                    $$=newNode("Exp");
                    addChild($$, $1);
                    addChild($$, $2);
                    addChild($$, $3);
                }
            | Exp PLUS Exp
                {
                    $$=newNode("Exp");
                    addChild($$, $1);
                    addChild($$, $2);
                    addChild($$, $3);
                }
            | Exp MINUS Exp
                {
                    $$=newNode("Exp");
                    addChild($$, $1);
                    addChild($$, $2);
                    addChild($$, $3);
                }
            | Exp STAR Exp
                {
                    $$=newNode("Exp");
                    addChild($$, $1);
                    addChild($$, $2);
                    addChild($$, $3);
                }
            | Exp DIV Exp
                {
                    $$=newNode("Exp");
                    addChild($$, $1);
                    addChild($$, $2);
                    addChild($$, $3);
                }
            | LP Exp RP
                {
                    $$=newNode("Exp");
                    addChild($$, $1);
                    addChild($$, $2);
                    addChild($$, $3);
                }
            | MINUS Exp
                {
                    $$=newNode("Exp");
                    addChild($$, $1);
                    addChild($$, $2);
                }
            | NOT Exp
                {
                    $$=newNode("Exp");
                    addChild($$, $1);
                    addChild($$, $2);
                }
            | ID LP Args RP
                {
                    $$=newNode("Exp");
                    addChild($$, $1);
                    addChild($$, $2);
                    addChild($$, $3);
                    addChild($$, $4);
                }
            | ID LP RP
                {
                    $$=newNode("Exp");
                    addChild($$, $1);
                    addChild($$, $2);
                    addChild($$, $3);
                }
            | Exp LB Exp RB
                {
                    $$=newNode("Exp");
                    addChild($$, $1);
                    addChild($$, $2);
                    addChild($$, $3);
                    addChild($$, $4);
                }
            | Exp DOT ID
                {
                    $$=newNode("Exp");
                    addChild($$, $1);
                    addChild($$, $2);
                    addChild($$, $3);
                }
            | ID
                {
                    $$=newNode("Exp");
                    addChild($$, $1);
                }
            | INT
                {
                    $$=newNode("Exp");
                    addChild($$, $1);
                }
            | FLOAT
                {
                    $$=newNode("Exp");
                    addChild($$, $1);
                }
            | error RP
                {
                    fprintf(stderr, "Invalid expression.\n");
                }
            ;
Args        : Exp COMMA Args
                {
                    $$=newNode("Args");
                    addChild($$, $1);
                    addChild($$, $2);
                    addChild($$, $3);
                }
            | Exp
                {
                    $$=newNode("Args");
                    addChild($$, $1);
                }
            ;

%%

int yyerror(char* msg) {
	fprintf(stderr, "Error type B at line %d: ", yylineno, msg);
	errornum++;
	return 0;
}
