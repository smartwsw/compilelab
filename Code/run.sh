#!/bin/bash
flex lexical.l
gcc -o test lex.yy.c -lfl
./test ../Test/test1.cmm
