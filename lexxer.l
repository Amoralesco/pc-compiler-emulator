%{
//keywords
#define KW 200
#define IF 201
#define THEN 202
#define ELSE 203
#define WHILE 204
#define DO 205
#define FOR 206
#define BREAK 207
#define CONTINUE 208
#define TRUE 209
#define FALSE 210
#define RETURN 211


#define RELOP 400
#define ARITOP 401
#define LOGICOP 402
#define DATATYPE 403
#define SYMBOL 404
#define ASOP 405
#define MODIFYOP 406


//datatypes 
#define INT 801
#define FLOAT 802
#define DOUBLE 803
#define CHAR 804
#define BOOLEAN 805
#define VOID 806 //function
#define STRING 807
#define NONE 808
#define FUNCTION 809


//comparative operators 
#define LT 1
#define LE 2
#define EQ 3
#define NE 4
#define GT 5
#define GE 6

//logic operators
#define AND 20
#define OR 21
#define NOT 22

//aritmetic operators
#define ADD 50
#define SUB 51
#define MUL 52
#define DIV 53
#define POW 54
#define SQRT 55
#define MOD 56
#define INTDIV 57


//assignation operator
#define AS 70
#define ADDAS 71
#define SUBAS 72
#define MULAS 73
#define DIVAS 74

//modify operator
#define INC 90
#define DEC 91



//special characters
#define OPEN_PARENTHESIS 100 
#define CLOSE_PARENTHESIS 101
#define OPEN_BRACKET 102
#define CLOSE_BRACKET 103 
#define OPEN_BRACE 104 // {
#define CLOSE_BRACE 105 // }
#define SEMI_COLON 106 // ;
#define COMMA 107 
#define NEGATION_SYMBOL 108 // !
#define OR_SYMBOL 109 // ||
#define AND_SYMBOL 110 // &&



//value identifiers
#define NUMBER 500
#define ID 501
#define WORD 502  //identifier for string


#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_IDS 100
#define MAX_NUMS 100
#define MAX_STRING 100

typedef struct {
    char *lexeme;
} IDEntry;

typedef struct {
    double value;
} NumEntry;

typedef struct {
    char *lexeme;
} StringEntry;


IDEntry idTable[MAX_IDS];
int idCount = 0;

NumEntry numTable[MAX_NUMS];
int numCount = 0;

StringEntry stringTable[MAX_STRING];
int stringCount = 0;      

int installString();
int installID();
int installNum();

int yylval;
%}

/* definiciones regulares */
delim   [ \t\n]
ws      {delim}+
letter  [A-Za-z]
digit   [0-9]
id      {letter}({letter}|{digit})*
number  {digit}+(\.{digit}+)?(E[+-]?{digit}+)?
string  \"([^\"\\]|\\.)*\"
linecomment  "//".*


%%
{ws}        /* ignora espacios en blanco */
"if"        { yylval = IF; printf("KW:%d ", yylval);return(KW); }
"then"      { yylval = THEN; printf("KW:%d ", yylval); return(KW); }
"else"      { yylval = ELSE; printf("KW:%d ", yylval); return(KW); }
"while"     { yylval = WHILE; printf("KW:%d ", yylval); return(KW); }
"do"        { yylval = DO; printf("KW:%d ", yylval); return(KW); }
"for"       { yylval = FOR; printf("KW:%d ", yylval); return(KW); }
"break"     { yylval = BREAK; printf("KW:%d ", yylval); return(KW); }
"continue"  { yylval = CONTINUE; printf("KW:%d ", yylval); return(KW); }
"true"      { yylval = TRUE; printf("KW:%d ", yylval); return(KW); }
"false"     { yylval = FALSE; printf("KW:%d ", yylval); return(KW); }
"return"    { yylval = RETURN; printf("KW:%d ", yylval); return(KW); }


"=="        { yylval = EQ; printf("RELOP:%d ", yylval); return(RELOP); }
"!="        { yylval = NE; printf("RELOP:%d ", yylval); return(RELOP); }
"<"         { yylval = LT; printf("RELOP:%d ", yylval); return(RELOP); }
"<="        { yylval = LE; printf("RELOP:%d ", yylval); return(RELOP); }
">"         { yylval = GT; printf("RELOP:%d ", yylval); return(RELOP); }
">="        { yylval = GE; printf("RELOP:%d ", yylval); return(RELOP); }

"+"         { yylval = ADD; printf("ARITOP:%d ", yylval); return(ARITOP); }
"-"         { yylval = SUB; printf("ARITOP:%d ", yylval); return(ARITOP); }
"*"         { yylval = MUL; printf("ARITOP:%d ", yylval); return(ARITOP); }
"/"         { yylval = DIV; printf("ARITOP:%d ", yylval); return(ARITOP); }
"**"        { yylval = POW; printf("ARITOP:%d ", yylval); return(ARITOP); }
"$$"        { yylval = SQRT; printf("ARITOP:%d ", yylval); return(ARITOP); }
"%%"        { yylval = MOD; printf("ARITOP:%d ", yylval); return(ARITOP); }
"//"        { yylval = INTDIV; printf("ARITOP:%d ", yylval); return(ARITOP); }

"="         { yylval = AS; printf("AS:%d ", yylval); return(AS); }
"+="        { yylval = ADDAS; printf("AS:%d ", yylval); return(AS); }
"-="        { yylval = SUBAS; printf("AS:%d ", yylval); return(AS); }
"*="        { yylval = MULAS; printf("AS:%d ", yylval); return(AS); }
"/="        { yylval = DIVAS; printf("AS:%d ", yylval); return(AS); }

"++"        { yylval = INC; printf("MODIFYOP:%d ", yylval); return(MODIFYOP); }
"--"        { yylval = DEC; printf("MODIFYOP:%d ", yylval); return(MODIFYOP); }

"("         { yylval = OPEN_PARENTHESIS; printf("SYMBOL:%d ", yylval); return(SYMBOL); }
")"         { yylval = CLOSE_PARENTHESIS; printf("SYMBOL:%d ", yylval); return(SYMBOL); }
"{"         { yylval = OPEN_BRACE; printf("SYMBOL:%d ", yylval); return(SYMBOL); }
"}"         { yylval = CLOSE_BRACE; printf("SYMBOL:%d ", yylval); return(SYMBOL); }
"["         { yylval = OPEN_BRACKET; printf("SYMBOL:%d ", yylval); return(SYMBOL); }
"]"         { yylval = CLOSE_BRACKET; printf("SYMBOL:%d ", yylval); return(SYMBOL); }
";"         { yylval = SEMI_COLON; printf("SYMBOL:%d ", yylval); return(SYMBOL); }
"&&"        { yylval = AND_SYMBOL; printf("SYMBOL:%d ", yylval); return(SYMBOL); }
"||"        { yylval = OR_SYMBOL; printf("SYMBOL:%d ", yylval); return(SYMBOL); }
"!"         { yylval = NEGATION_SYMBOL; printf("SYMBOL:%d ", yylval); return(SYMBOL); }
","         { yylval = COMMA; printf("SYMBOL:%d ", yylval); return(SYMBOL); }

"int"       { yylval = INT; printf("DATATYPE:%d ", yylval); return(DATATYPE); }
"float"     { yylval = FLOAT; printf("DATATYPE:%d ", yylval); return(DATATYPE); }
"double"    { yylval = DOUBLE; printf("DATATYPE:%d ", yylval); return(DATATYPE); }
"char"      { yylval = CHAR; printf("DATATYPE:%d ", yylval); return(DATATYPE); }
"bool"      { yylval = BOOLEAN; printf("DATATYPE:%d ", yylval); return(DATATYPE); }
"void"      { yylval = VOID; printf("DATATYPE:%d ", yylval); return(DATATYPE); }
"string"    { yylval = STRING; printf("DATATYPE:%d ", yylval); return(DATATYPE); }
"none"      { yylval = NONE; printf("DATATYPE:%d ", yylval); return(DATATYPE); }
"function"  { yylval = FUNCTION; printf("DATATYPE:%d ", yylval); return(DATATYPE); }

{number}    { yylval = installNum(); printf("%d ", yylval); return(NUMBER); }
{id}        { yylval = installID(); printf("%d ", yylval); return(ID); }
{string}    { yylval = installString(); printf("%d ", yylval); return(STRING); }
{linecomment}   /* ignora los comentarios */

.      { printf("Error: caracter no reconocido '%c'\n", yytext[0]); }
%%

int installID() {
    if (idCount < MAX_IDS) {
        idTable[idCount].lexeme = strdup(yytext);
        return idCount++;
    } else {
        fprintf(stderr, "Tabla de IDs llena.\n");
        exit(1);
    }
}

int installNum() {
    if (numCount < MAX_NUMS) {
        numTable[numCount].value = atof(yytext);
        return numCount++;
    } else {
        fprintf(stderr, "Tabla de Números llena.\n");
        exit(1);
    }
}

int installString() {
    if (stringCount < MAX_STRING) {
        // Elimina las comillas iniciales y finales
        size_t len = strlen(yytext);
        if (len < 2) {
            fprintf(stderr, "Error: Cadena vacía.\n");
            exit(1);
        }
        // Reserva memoria para la cadena sin las comillas
        char *str = (char *)malloc(len - 1);
        if (!str) {
            fprintf(stderr, "Error: Memoria insuficiente para almacenar la cadena.\n");
            exit(1);
        }
        strncpy(str, yytext + 1, len - 2);
        str[len - 2] = '\0';
        
        stringTable[stringCount].lexeme = str;
        return stringCount++;
    } else {
        fprintf(stderr, "Tabla de Strings llena.\n");
        exit(1);
    }
}