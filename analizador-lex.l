%{
// Keywords
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

// Palabras reservadas del modelo de actores y bigrafos
#define ACTOR 212
#define SPAWN 213
#define SEND 214
#define RECEIVE 215
#define SELF 216
#define BECOME 217
#define PLACE 218
#define LINK 219
#define MOVE 220
#define DISCONNECT 221
#define MONITOR 222      // monitorear actores
#define SUPERVISOR 223   // definir un supervisor
#define STOP 224         // detener un actor
#define FAIL 225         // indicar un fallo

// Concurrencia
#define ASYNC 226        // ejecución asíncrona
#define AWAIT 227        // esperar una tarea asíncrona
#define MUTEX 228        // exclusión mutua
#define LOCK 229         // bloquear un recurso
#define UNLOCK 230       // desbloquear un recurso

// Manejo de errores
#define TRY 231          // anejo de excepciones
#define CATCH 232        // capturar excepciones
#define RETRY 233        // reintentar una operación

// Tiempo
#define TIMER 234        // definir un temporizador
#define DELAY 235        // retrasar la ejecución

// Persistencia
#define STORE 236        // almacenar el estado de un actor
#define RESTORE 237      // recuperar el estado de un actor

// Operadores y tipos
#define RELOP 400
#define ARITOP 401
#define LOGICOP 402
#define DATATYPE 403
#define SYMBOL 404
#define ASOP 405
#define MODIFYOP 406
#define MSG_OP 407   // Operadores de mensajes (send/receive)
#define BG_OP 408    // Operadores de bigrafos (link/disconnect/move)

// Tipos de datos
#define INT 801
#define FLOAT 802
#define DOUBLE 803
#define CHAR 804
#define BOOLEAN 805
#define VOID 806
#define STRING 807
#define NONE 808
#define FUNCTION 809

// Operadores comparativos
#define LT 1
#define LE 2
#define EQ 3
#define NE 4
#define GT 5
#define GE 6

// Operadores lógicos
#define AND 20
#define OR 21
#define NOT 22

// Operadores aritméticos
#define ADD 50
#define SUB 51
#define MUL 52
#define DIV 53
#define POW 54
#define SQRT 55
#define MOD 56
#define INTDIV 57

// Operadores de asignación
#define AS 70
#define ADDAS 71
#define SUBAS 72
#define MULAS 73
#define DIVAS 74

// Operadores de modificación
#define INC 90
#define DEC 91

// Operadores de mensajes
#define SEND_OP 120
#define RECV_OP 121

// Operadores de bigrafos
#define LINK_OP 122
#define DISCONNECT_OP 123
#define MOVE_OP 124

// Caracteres especiales
#define OPEN_PARENTHESIS 100
#define CLOSE_PARENTHESIS 101
#define OPEN_BRACKET 102
#define CLOSE_BRACKET 103
#define OPEN_BRACE 104
#define CLOSE_BRACE 105
#define SEMI_COLON 106
#define COMMA 107
#define NEGATION_SYMBOL 108
#define OR_SYMBOL 109
#define AND_SYMBOL 110

// Identificadores de valores
#define NUMBER 500
#define ID 501
#define WORD 502

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_IDS 100
#define MAX_NUMS 100
#define MAX_STRING 100

/* Definiciones de las estructuras */
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

/* Definiciones regulares */
delim   [ \t\n]
ws      {delim}+
letter  [A-Za-z]
digit   [0-9]
number  {digit}+(\.{digit}+)?(E[+-]?{digit}+)?
id      {letter}({letter}|{digit})*
string  \"([^\"\\]|\\.)*\"
linecomment  "//".*
blockcomment \/\*[^*]*\*+([^/*][^*]*\*+)*\/

%%
{ws}        /* ignora espacios en blanco */

"if"        { yylval = IF; printf("%d %d ", KW, yylval); return(KW); }
"then"      { yylval = THEN; printf("%d %d ", KW, yylval); return(KW); }
"else"      { yylval = ELSE; printf("%d %d ", KW, yylval); return(KW); }
"while"     { yylval = WHILE; printf("%d %d ", KW, yylval); return(KW); }
"do"        { yylval = DO; printf("%d %d ", KW, yylval); return(KW); }
"for"       { yylval = FOR; printf("%d %d ", KW, yylval); return(KW); }
"break"     { yylval = BREAK; printf("%d %d ", KW, yylval); return(KW); }
"continue"  { yylval = CONTINUE; printf("%d %d ", KW, yylval); return(KW); }
"true"      { yylval = TRUE; printf("%d %d ", KW, yylval); return(KW); }
"false"     { yylval = FALSE; printf("%d %d ", KW, yylval); return(KW); }
"return"    { yylval = RETURN; printf("%d %d ", KW, yylval); return(KW); }

"actor"      { yylval = ACTOR; printf("%d %d ", KW, yylval); return(KW); }
"spawn"      { yylval = SPAWN; printf("%d %d ", KW, yylval); return(KW); }
"send"       { yylval = SEND; printf("%d %d ", KW, yylval); return(KW); }
"receive"    { yylval = RECEIVE; printf("%d %d ", KW, yylval); return(KW); }
"self"       { yylval = SELF; printf("%d %d ", KW, yylval); return(KW); }
"become"     { yylval = BECOME; printf("%d %d ", KW, yylval); return(KW); }
"monitor"    { yylval = MONITOR; printf("%d %d ", KW, yylval); return(KW); }
"supervisor" { yylval = SUPERVISOR; printf("%d %d ", KW, yylval); return(KW); }
"stop"       { yylval = STOP; printf("%d %d ", KW, yylval); return(KW); }
"fail"       { yylval = FAIL; printf("%d %d ", KW, yylval); return(KW); }

"async"      { yylval = ASYNC; printf("%d %d ", KW, yylval); return(KW); }
"await"      { yylval = AWAIT; printf("%d %d ", KW, yylval); return(KW); }
"mutex"      { yylval = MUTEX; printf("%d %d ", KW, yylval); return(KW); }
"lock"       { yylval = LOCK; printf("%d %d ", KW, yylval); return(KW); }
"unlock"     { yylval = UNLOCK; printf("%d %d ", KW, yylval); return(KW); }

"try"        { yylval = TRY; printf("%d %d ", KW, yylval); return(KW); }
"catch"      { yylval = CATCH; printf("%d %d ", KW, yylval); return(KW); }
"retry"      { yylval = RETRY; printf("%d %d ", KW, yylval); return(KW); }

"timer"      { yylval = TIMER; printf("%d %d ", KW, yylval); return(KW); }
"delay"      { yylval = DELAY; printf("%d %d ", KW, yylval); return(KW); }

"store"      { yylval = STORE; printf("%d %d ", KW, yylval); return(KW); }
"restore"    { yylval = RESTORE; printf("%d %d ", KW, yylval); return(KW); }

"place"      { yylval = PLACE; printf("%d %d ", KW, yylval); return(KW); }
"link"       { yylval = LINK; printf("%d %d ", KW, yylval); return(KW); }
"move"       { yylval = MOVE; printf("%d %d ", KW, yylval); return(KW); }
"disconnect" { yylval = DISCONNECT; printf("%d %d ", KW, yylval); return(KW); }

"=="        { yylval = EQ; printf("%d %d ", RELOP, yylval); return(RELOP); }
"!="        { yylval = NE; printf("%d %d ", RELOP, yylval); return(RELOP); }
"<"         { yylval = LT; printf("%d %d ", RELOP, yylval); return(RELOP); }
"<="        { yylval = LE; printf("%d %d ", RELOP, yylval); return(RELOP); }
">"         { yylval = GT; printf("%d %d ", RELOP, yylval); return(RELOP); }
">="        { yylval = GE; printf("%d %d ", RELOP, yylval); return(RELOP); }

"+"         { yylval = ADD; printf("%d %d ", ARITOP, yylval); return(ARITOP); }
"-"         { yylval = SUB; printf("%d %d ", ARITOP, yylval); return(ARITOP); }
"*"         { yylval = MUL; printf("%d %d ", ARITOP, yylval); return(ARITOP); }
"/"         { yylval = DIV; printf("%d %d ", ARITOP, yylval); return(ARITOP); }
"**"        { yylval = POW; printf("%d %d ", ARITOP, yylval); return(ARITOP); }
"$$"        { yylval = SQRT; printf("%d %d ", ARITOP, yylval); return(ARITOP); }
"%%"        { yylval = MOD; printf("%d %d ", ARITOP, yylval); return(ARITOP); }
"//"        { yylval = INTDIV; printf("%d %d ", ARITOP, yylval); return(ARITOP); }

"="         { yylval = AS; printf("%d %d ", ASOP, yylval); return(ASOP); }
"+="        { yylval = ADDAS; printf("%d %d ", ASOP, yylval); return(ASOP); }
"-="        { yylval = SUBAS; printf("%d %d ", ASOP, yylval); return(ASOP); }
"*="        { yylval = MULAS; printf("%d %d ", ASOP, yylval); return(ASOP); }
"/="        { yylval = DIVAS; printf("%d %d ", ASOP, yylval); return(ASOP); }

"++"        { yylval = INC; printf("%d %d ", MODIFYOP, yylval); return(MODIFYOP); }
"--"        { yylval = DEC; printf("%d %d ", MODIFYOP, yylval); return(MODIFYOP); }

"<-"        { yylval = SEND_OP; printf("%d %d ", MSG_OP, yylval); return(MSG_OP); }
"->"        { yylval = RECV_OP; printf("%d %d ", MSG_OP, yylval); return(MSG_OP); }

"<=>"       { yylval = LINK_OP; printf("%d %d ", BG_OP, yylval); return(BG_OP); }

"("         { yylval = OPEN_PARENTHESIS; printf("%d %d ", SYMBOL, yylval); return(SYMBOL); }
")"         { yylval = CLOSE_PARENTHESIS; printf("%d %d ", SYMBOL, yylval); return(SYMBOL); }
"{"         { yylval = OPEN_BRACE; printf("%d %d ", SYMBOL, yylval); return(SYMBOL); }
"}"         { yylval = CLOSE_BRACE; printf("%d %d ", SYMBOL, yylval); return(SYMBOL); }
"["         { yylval = OPEN_BRACKET; printf("%d %d ", SYMBOL, yylval); return(SYMBOL); }
"]"         { yylval = CLOSE_BRACKET; printf("%d %d ", SYMBOL, yylval); return(SYMBOL); }
";"         { yylval = SEMI_COLON; printf("%d %d ", SYMBOL, yylval); return(SYMBOL); }
"&&"        { yylval = AND_SYMBOL; printf("%d %d ", SYMBOL, yylval); return(SYMBOL); }
"||"        { yylval = OR_SYMBOL; printf("%d %d ", SYMBOL, yylval); return(SYMBOL); }
"!"         { yylval = NEGATION_SYMBOL; printf("%d %d ", SYMBOL, yylval); return(SYMBOL); }
","         { yylval = COMMA; printf("%d %d ", SYMBOL, yylval); return(SYMBOL); }

"int"       { yylval = INT; printf("%d %d ", DATATYPE, yylval); return(DATATYPE); }
"float"     { yylval = FLOAT; printf("%d %d ", DATATYPE, yylval); return(DATATYPE); }
"double"    { yylval = DOUBLE; printf("%d %d ", DATATYPE, yylval); return(DATATYPE); }
"char"      { yylval = CHAR; printf("%d %d ", DATATYPE, yylval); return(DATATYPE); }
"bool"      { yylval = BOOLEAN; printf("%d %d ", DATATYPE, yylval); return(DATATYPE); }
"void"      { yylval = VOID; printf("%d %d ", DATATYPE, yylval); return(DATATYPE); }
"string"    { yylval = STRING; printf("%d %d ", DATATYPE, yylval); return(DATATYPE); }
"none"      { yylval = NONE; printf("%d %d ", DATATYPE, yylval); return(DATATYPE); }
"function"  { yylval = FUNCTION; printf("%d %d ", DATATYPE, yylval); return(DATATYPE); }

{number}    { yylval = installNum(); printf("%d ", yylval); return(NUMBER); }
{id}        { yylval = installID(); printf("%d ", yylval); return(ID); }
{string}    { yylval = installString(); printf("%d ", yylval); return(STRING); }
{linecomment}   /* ignora comentarios de una línea */
{blockcomment}  /* ignora comentarios en bloque */

.      { printf("Error: caracter no reconocido '%c'\n", yytext[0]); }
%%

int installID() {
    for (int i = 0; i < idCount; i++) {
        if (strcmp(idTable[i].lexeme, yytext) == 0) {
            return i;
        }
    }

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
        size_t len = strlen(yytext);
        if (len < 2) {
            fprintf(stderr, "Error: Cadena vacía.\n");
            exit(1);
        }
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